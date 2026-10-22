--
-- PostgreSQL database dump
--

\restrict 0kEhemjDqkvags1ib5h4Yu6jUz4oIXc5mdhBQaKPpwyAQpXMMzbTA4cq85TFckQ

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-22 16:10:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 16469)
-- Name: error_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.error_logs (
    error_id integer NOT NULL,
    logged_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    pipeline_stage character varying(100) NOT NULL,
    failure_reason character varying(255) NOT NULL,
    raw_ean character varying(100),
    raw_expiration_date character varying(50),
    quantity integer,
    execution_time timestamp(0) without time zone NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 16468)
-- Name: error_logs_error_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.error_logs_error_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 220
-- Name: error_logs_error_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.error_logs_error_id_seq OWNED BY public.error_logs.error_id;


--
-- TOC entry 224 (class 1259 OID 16624)
-- Name: inventory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory (
    product_id integer NOT NULL,
    expiration_date date NOT NULL,
    quantity numeric NOT NULL,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT inventory_quantity_check CHECK ((quantity >= (0)::numeric))
);


--
-- TOC entry 219 (class 1259 OID 16453)
-- Name: pipeline_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pipeline_executions (
    execution_time timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    invalid_ean_count integer DEFAULT 0 NOT NULL,
    unmatched_api_count integer DEFAULT 0 NOT NULL,
    success_count integer DEFAULT 0 NOT NULL,
    unmatched_csv_count integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16613)
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(255) NOT NULL,
    size character varying(100),
    categories character varying(150),
    allergens text,
    image_front_url text
);


--
-- TOC entry 222 (class 1259 OID 16612)
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.products ALTER COLUMN product_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 25076)
-- Name: temp_inventory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.temp_inventory (
    product_name character varying,
    quantity double precision,
    expiration_date date
);


--
-- TOC entry 4878 (class 2604 OID 16472)
-- Name: error_logs error_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.error_logs ALTER COLUMN error_id SET DEFAULT nextval('public.error_logs_error_id_seq'::regclass);


--
-- TOC entry 5043 (class 0 OID 16469)
-- Dependencies: 221
-- Data for Name: error_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.error_logs (error_id, logged_at, pipeline_stage, failure_reason, raw_ean, raw_expiration_date, quantity, execution_time) FROM stdin;
1	2026-10-15 04:03:15.151639	EAN Validation	EAN-13 format	56010491329	27/03/2027	70	2026-10-15 04:03:15
2	2026-10-15 04:05:18.307418	EAN Validation	EAN-13 format	56010491329	27/03/2027	70	2026-10-15 04:05:18
3	2026-10-15 04:08:49.876915	EAN Validation	EAN-13 format	56010491329	27/03/2027	70	2026-10-15 04:08:50
4	2026-10-15 04:10:54.35136	API Enrichment (Join)	EAN not found in API	2000000000010	05/01/2028	1	2026-10-15 04:10:54
5	2026-10-15 04:10:54.35136	EAN Validation	EAN-13 format	56010491329	27/03/2027	70	2026-10-15 04:10:54
6	2026-10-15 04:26:28.449691	API Enrichment (Join)	EAN not found in API	2000000000010	05/01/2028	1	2026-10-15 04:26:28
7	2026-10-15 04:26:28.449691	EAN Validation	EAN-13 format	56010491329	27/03/2027	70	2026-10-15 04:26:28
8	2026-10-15 04:27:39.639404	API Enrichment (Join)	EAN not found in API	2000000000010	05/01/2028	1	2026-10-15 04:27:39
9	2026-10-15 04:27:39.639404	EAN Validation	EAN-13 format	56010491329	27/03/2027	70	2026-10-15 04:27:39
10	2026-10-15 04:37:18.030478	API Enrichment (Join)	EAN not found in API	2000000000010	05/01/2028	1	2026-10-15 04:37:18
11	2026-10-15 04:37:18.030478	EAN Validation	EAN-13 format	56010491329	27/03/2027	70	2026-10-15 04:37:18
12	2026-10-16 02:03:48.354113	EAN Validation	EAN-13 format	84105000794	29/10/2026	4	2026-10-16 02:03:48
13	2026-10-16 02:49:41.77725	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-16 02:49:42
14	2026-10-16 13:02:16.619102	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-16 13:02:16
15	2026-10-16 19:35:01.745366	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-16 19:35:01
16	2026-10-16 20:03:23.01297	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-16 20:03:21
17	2026-10-17 00:21:58.001988	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-17 00:21:54
18	2026-10-17 00:25:34.59354	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-17 00:25:34
19	2026-10-17 00:28:38.088846	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-17 00:28:35
20	2026-10-17 00:29:00.256456	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-17 00:28:59
21	2026-10-17 23:33:44.0584	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-17 23:33:30
22	2026-10-17 23:34:16.175188	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-17 23:34:15
23	2026-10-19 19:26:04.220246	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-19 19:25:55
24	2026-10-20 01:40:29.545744	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-20 01:40:15
25	2026-10-20 01:43:32.646732	Product Matching	EAN not found in CSV	8410500028794	\N	\N	2026-10-20 01:43:31
26	2026-10-20 04:09:33.17892	API Enrichment (Join)	EAN not found in API	5601009011214	2027-05-15	\N	2026-10-20 04:09:32
\.


--
-- TOC entry 5046 (class 0 OID 16624)
-- Dependencies: 224
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory (product_id, expiration_date, quantity, last_updated) FROM stdin;
2	2026-10-29	20	2026-10-15 04:27:39.618543
3	2099-12-31	637.0	2026-10-16 13:02:16.596512
4	2099-12-31	420	2026-10-16 13:02:16.596512
5	2099-12-31	1680	2026-10-16 13:02:16.596512
6	2099-12-31	840	2026-10-16 13:02:16.596512
1	2026-12-02	759	2026-10-15 02:29:48.410146
1	2027-03-27	3960	2026-10-15 02:29:48.410146
1	2027-05-15	96	2026-10-20 04:06:43.900856
7	2099-12-31	105	2026-10-20 04:06:43.900856
1	2026-10-23	72	2026-10-20 05:13:37.461267
\.


--
-- TOC entry 5041 (class 0 OID 16453)
-- Dependencies: 219
-- Data for Name: pipeline_executions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pipeline_executions (execution_time, invalid_ean_count, unmatched_api_count, success_count, unmatched_csv_count) FROM stdin;
2026-10-15 03:47:47	0	0	2	0
2026-10-15 04:03:15	1	0	2	0
2026-10-15 04:05:18	1	0	2	0
2026-10-15 04:08:50	1	0	2	0
2026-10-15 04:10:54	1	1	2	0
2026-10-15 04:26:28	1	1	2	0
2026-10-15 04:27:39	1	1	3	0
2026-10-15 04:37:18	1	1	3	0
2026-10-15 05:12:55	0	0	3	0
2026-10-16 02:01:03	0	0	3	0
2026-10-16 02:03:48	1	0	3	0
2026-10-16 02:04:59	0	0	2	0
2026-10-16 02:25:42	0	0	2	0
2026-10-16 02:39:47	0	0	2	0
2026-10-16 02:40:48	0	0	2	0
2026-10-16 02:49:42	0	0	2	0
2026-10-16 13:02:16	0	0	6	0
2026-10-16 19:35:01	0	0	6	0
2026-10-16 20:03:21	0	0	6	0
2026-10-17 00:21:54	0	0	6	0
2026-10-17 00:25:34	0	0	6	0
2026-10-17 00:28:35	0	0	6	0
2026-10-17 00:28:59	0	0	6	0
2026-10-17 23:33:30	0	1	6	0
2026-10-17 23:34:15	0	1	6	0
2026-10-19 19:25:55	0	1	6	0
2026-10-20 01:40:15	0	1	6	0
2026-10-20 01:43:31	0	1	6	0
2026-10-20 04:06:43	0	0	2	1
2026-10-20 04:09:32	0	0	2	1
2026-10-20 05:02:09	0	0	2	0
2026-10-20 05:08:23	0	0	2	0
2026-10-20 05:13:34	0	0	2	0
2026-10-21 01:25:59	0	0	2	0
2026-10-21 01:42:44	0	0	2	0
\.


--
-- TOC entry 5045 (class 0 OID 16613)
-- Dependencies: 223
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (product_id, product_name, size, categories, allergens, image_front_url) FROM stdin;
3	Maca Riscadinha	\N	Fruits	\N	\N
4	alface frisada	\N	Vegetables	\N	\N
5	PAO DE MISTURA	\N	Bakery	\N	\N
6	Banana da Madeira	\N	Fruits	\N	\N
2	Griego natural	440	Yogures estilo griego, Yogures naturales	leche	https://images.openfoodfacts.org/images/products/841/050/002/8794/front_es.35.400.jpg
7	Pão	\N	Padaria	\N	\N
1	Leite	1000ml	Leite	leite	https://images.openfoodfacts.org/images/products/560/104/913/2995/front_pt.85.400.jpg
\.


--
-- TOC entry 5047 (class 0 OID 25076)
-- Dependencies: 225
-- Data for Name: temp_inventory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.temp_inventory (product_name, quantity, expiration_date) FROM stdin;
Pão	15	2099-12-31
Leite	24	2026-10-23
\.


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 220
-- Name: error_logs_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.error_logs_error_id_seq', 26, true);


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 222
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_product_id_seq', 7, true);


--
-- TOC entry 4885 (class 2606 OID 16482)
-- Name: error_logs error_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.error_logs
    ADD CONSTRAINT error_logs_pkey PRIMARY KEY (error_id);


--
-- TOC entry 4891 (class 2606 OID 16634)
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (product_id, expiration_date);


--
-- TOC entry 4883 (class 2606 OID 16690)
-- Name: pipeline_executions pipeline_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pipeline_executions
    ADD CONSTRAINT pipeline_executions_pkey PRIMARY KEY (execution_time);


--
-- TOC entry 4887 (class 2606 OID 16621)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4889 (class 2606 OID 16623)
-- Name: products products_product_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_product_name_key UNIQUE (product_name);


--
-- TOC entry 4892 (class 2606 OID 16692)
-- Name: error_logs error_logs_execution_time_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.error_logs
    ADD CONSTRAINT error_logs_execution_time_fkey FOREIGN KEY (execution_time) REFERENCES public.pipeline_executions(execution_time);


--
-- TOC entry 4893 (class 2606 OID 16635)
-- Name: inventory inventory_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON UPDATE CASCADE;


-- Completed on 2026-10-22 16:10:35

--
-- PostgreSQL database dump complete
--

\unrestrict 0kEhemjDqkvags1ib5h4Yu6jUz4oIXc5mdhBQaKPpwyAQpXMMzbTA4cq85TFckQ

