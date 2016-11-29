--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: check_expiration_date(); Type: FUNCTION; Schema: public; Owner: pep
--

CREATE FUNCTION check_expiration_date() RETURNS trigger
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


ALTER FUNCTION public.check_expiration_date() OWNER TO pep;

--
-- Name: create_or_update_availability(); Type: FUNCTION; Schema: public; Owner: pep
--

CREATE FUNCTION create_or_update_availability() RETURNS trigger
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


ALTER FUNCTION public.create_or_update_availability() OWNER TO pep;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: pep; Tablespace: 
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE ar_internal_metadata OWNER TO pep;

--
-- Name: availabilities; Type: TABLE; Schema: public; Owner: pep; Tablespace: 
--

CREATE TABLE availabilities (
    id integer NOT NULL,
    product_id integer,
    amount integer
);


ALTER TABLE availabilities OWNER TO pep;

--
-- Name: availabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: pep
--

CREATE SEQUENCE availabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE availabilities_id_seq OWNER TO pep;

--
-- Name: availabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pep
--

ALTER SEQUENCE availabilities_id_seq OWNED BY availabilities.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: pep; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE categories OWNER TO pep;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: pep
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categories_id_seq OWNER TO pep;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pep
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: pep; Tablespace: 
--

CREATE TABLE deliveries (
    id integer NOT NULL,
    provider_id integer,
    product_id integer,
    price numeric,
    amount integer,
    delivery_date date
);


ALTER TABLE deliveries OWNER TO pep;

--
-- Name: deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: pep
--

CREATE SEQUENCE deliveries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE deliveries_id_seq OWNER TO pep;

--
-- Name: deliveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pep
--

ALTER SEQUENCE deliveries_id_seq OWNED BY deliveries.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: pep; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    category_id integer,
    made date,
    expiration integer,
    name character varying,
    price numeric
);


ALTER TABLE products OWNER TO pep;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: pep
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE products_id_seq OWNER TO pep;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pep
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: providers; Type: TABLE; Schema: public; Owner: pep; Tablespace: 
--

CREATE TABLE providers (
    id integer NOT NULL,
    address character varying,
    phone character varying
);


ALTER TABLE providers OWNER TO pep;

--
-- Name: providers_id_seq; Type: SEQUENCE; Schema: public; Owner: pep
--

CREATE SEQUENCE providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE providers_id_seq OWNER TO pep;

--
-- Name: providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pep
--

ALTER SEQUENCE providers_id_seq OWNED BY providers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: pep; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE schema_migrations OWNER TO pep;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pep
--

ALTER TABLE ONLY availabilities ALTER COLUMN id SET DEFAULT nextval('availabilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pep
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pep
--

ALTER TABLE ONLY deliveries ALTER COLUMN id SET DEFAULT nextval('deliveries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pep
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pep
--

ALTER TABLE ONLY providers ALTER COLUMN id SET DEFAULT nextval('providers_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: pep
--

COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2016-11-29 11:30:55.92063	2016-11-29 11:30:55.92063
\.


--
-- Data for Name: availabilities; Type: TABLE DATA; Schema: public; Owner: pep
--

COPY availabilities (id, product_id, amount) FROM stdin;
5	12	123
\.


--
-- Name: availabilities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pep
--

SELECT pg_catalog.setval('availabilities_id_seq', 5, true);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: pep
--

COPY categories (id, name) FROM stdin;
4	category#3
5	category#4
6	category#5
7	category#6
8	category#7
9	category#8
10	category#9
1	category#0
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pep
--

SELECT pg_catalog.setval('categories_id_seq', 10, true);


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: pep
--

COPY deliveries (id, provider_id, product_id, price, amount, delivery_date) FROM stdin;
41	1	12	12332.0	100	2016-11-01
42	3	12	1479.84	12	2016-11-02
43	3	12	13688.519999999999	111	2016-11-04
\.


--
-- Name: deliveries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pep
--

SELECT pg_catalog.setval('deliveries_id_seq', 43, true);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: pep
--

COPY products (id, category_id, made, expiration, name, price) FROM stdin;
12	4	2016-11-01	50	Молоко	123.32
\.


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pep
--

SELECT pg_catalog.setval('products_id_seq', 12, true);


--
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: pep
--

COPY providers (id, address, phone) FROM stdin;
3	address#2	09876543212
4	address#3	09876543213
5	address#4	09876543214
6	address#5	09876543215
7	address#6	09876543216
8	address#7	09876543217
9	address#8	09876543218
10	address#9	09876543219
1	address#0	09876543210
\.


--
-- Name: providers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pep
--

SELECT pg_catalog.setval('providers_id_seq', 10, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: pep
--

COPY schema_migrations (version) FROM stdin;
20161127140610
20161127140740
20161127140805
20161127140851
20161127140907
20161129114807
\.


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: pep; Tablespace: 
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: pep; Tablespace: 
--

ALTER TABLE ONLY availabilities
    ADD CONSTRAINT availabilities_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: pep; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: pep; Tablespace: 
--

ALTER TABLE ONLY deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: pep; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: providers_pkey; Type: CONSTRAINT; Schema: public; Owner: pep; Tablespace: 
--

ALTER TABLE ONLY providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: pep; Tablespace: 
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: check_expiration_trigger; Type: TRIGGER; Schema: public; Owner: pep
--

CREATE TRIGGER check_expiration_trigger BEFORE INSERT ON deliveries FOR EACH ROW EXECUTE PROCEDURE check_expiration_date();


--
-- Name: increment_availability_on_insert; Type: TRIGGER; Schema: public; Owner: pep
--

CREATE TRIGGER increment_availability_on_insert AFTER INSERT ON deliveries FOR EACH ROW EXECUTE PROCEDURE create_or_update_availability();


--
-- Name: increment_availability_on_update; Type: TRIGGER; Schema: public; Owner: pep
--

CREATE TRIGGER increment_availability_on_update AFTER UPDATE ON deliveries FOR EACH ROW EXECUTE PROCEDURE create_or_update_availability();


--
-- Name: public; Type: ACL; Schema: -; Owner: vs
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM vs;
GRANT ALL ON SCHEMA public TO vs;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

