class AddTriggers < ActiveRecord::Migration[5.1]
  def up
    execute "
    CREATE OR REPLACE FUNCTION check_expiration_date() RETURNS trigger
        LANGUAGE plpgsql
        AS $$
    DECLARE
    end_date date;
    exp integer;
    BEGIN
      SELECT expiration,made FROM products WHERE products.id = NEW.product_id INTO exp, end_date;
            IF end_date + exp < current_date THEN
                RAISE EXCEPTION 'Product has expired';
            END IF;
    RETURN NEW;
    END;
    $$;

    CREATE OR REPLACE FUNCTION create_or_update_availability() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
    -- first try to update the key
            UPDATE availabilities SET amount = amount + NEW.amount WHERE NEW.product_id = availabilities.product_id;
            IF found THEN
                RETURN NEW;
            END IF;
            -- not there, so try to insert the key
            -- if someone else inserts the same key concurrently,
            -- we could get a unique-key failure
            BEGIN
                INSERT INTO availabilities(product_id,amount) VALUES (NEW.product_id, NEW.amount);
                RETURN NEW;
            EXCEPTION WHEN unique_violation THEN
                -- Do nothing, and loop to try the UPDATE again.
            END;
    RETURN NEW;
    END;
    $$;

    CREATE TRIGGER check_expiration_trigger BEFORE INSERT ON deliveries FOR EACH ROW EXECUTE PROCEDURE check_expiration_date();
    
    
    --
    -- Name: increment_availability_on_insert; Type: TRIGGER; Schema: public; Owner: pep
    --
    
    CREATE TRIGGER increment_availability_on_insert AFTER INSERT ON deliveries FOR EACH ROW EXECUTE PROCEDURE create_or_update_availability();
    
    
    --
    -- Name: increment_availability_on_update; Type: TRIGGER; Schema: public; Owner: pep
    --
    
    CREATE TRIGGER increment_availability_on_update AFTER UPDATE ON deliveries FOR EACH ROW EXECUTE PROCEDURE create_or_update_availability();    
    "
  end

  def down
    execute("
      DROP TRIGGER IF EXISTS increment_availability_on_update ON deliveries;
      DROP TRIGGER IF EXISTS increment_availability_on_insert ON deliveries;
      DROP TRIGGER IF EXISTS check_expiration_trigger ON deliveries;
    ")
  end
end
