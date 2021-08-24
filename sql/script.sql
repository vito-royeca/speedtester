--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: speedtest(json); Type: FUNCTION; Schema: public; Owner: speedtest
--

CREATE FUNCTION public.speedtest(json) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _json ALIAS FOR $1;
    server_id bigint;
    client_id integer;
BEGIN
    --server
    SELECT id INTO server_id FROM server WHERE id = (_json->'server' ->> 'id')::bigint;

    IF NOT FOUND THEN
        INSERT INTO server(
            id,
            url,
            lat,
            lon,
            name,
            country,
            cc,
            sponsor,
            host,
            d,
            latency)
        VALUES(
            (_json->'server' ->> 'id')::bigint,
            (_json->'server' ->> 'url')::character varying,
            (_json->'server' ->> 'lat')::double precision,
            (_json->'server' ->> 'lon')::double precision,
            (_json->'server' ->> 'name')::character varying,
            (_json->'server' ->> 'country')::character varying,
            (_json->'server' ->> 'cc')::character varying,
            (_json->'server' ->> 'sponsor')::character varying,
            (_json->'server' ->> 'host')::character varying,
            (_json->'server' ->> 'd')::double precision,
            (_json->'server' ->> 'latency')::double precision);
		SELECT id INTO server_id FROM server WHERE id = (_json->'server' ->> 'id')::bigint;	
    ELSE
        UPDATE server SET
            url     = (_json->'server' ->> 'url')::character varying,
            lat     = (_json->'server' ->> 'lat')::double precision,
            lon     = (_json->'server' ->> 'lon')::double precision,
            name    = (_json->'server' ->> 'name')::character varying,
            country = (_json->'server' ->> 'country')::character varying,
            cc      = (_json->'server' ->> 'cc')::character varying,
            sponsor = (_json->'server' ->> 'sponsor')::character varying,
            host    = (_json->'server' ->> 'host')::character varying,
            d       = (_json->'server' ->> 'd')::double precision,
            latency  = (_json->'server' ->> 'latency')::double precision,
			date_updated = now()
        WHERE id = server_id;
    END IF;

    -- client
    SELECT id INTO client_id FROM client WHERE isp = _json->'client' ->> 'isp' AND country = _json->'client' ->> 'country';
    
    IF NOT FOUND THEN
        INSERT INTO client(
            id,
            ip,
            lat,
            lon,
            isp,
            country)
        VALUES(
            nextval('client_id_seq'),
            (_json->'client' ->> 'ip')::inet,
            (_json->'client' ->> 'lat')::double precision,
            (_json->'client' ->> 'lon')::double precision,
            (_json->'client' ->> 'isp')::character varying,
            (_json->'client' ->> 'country')::character varying);
		SELECT id INTO client_id FROM client WHERE isp = _json->'client' ->> 'isp' AND country = _json->'client' ->> 'country';	
    ELSE
        UPDATE client SET
            ip      = (_json->'client' ->> 'ip')::inet,
            lat     = (_json->'client' ->> 'lat')::double precision,
            lon     = (_json->'client' ->> 'lon')::double precision,
            isp     = (_json->'client' ->> 'isp')::character varying,
            country = (_json->'client' ->> 'country')::character varying,
			date_updated = now()
        WHERE id = client_id;
    END IF;

    -- speedtest
    INSERT INTO speedtest(
        id,
        server,
        client,
        download,
        upload,
        ping,
        bytes_sent,
        bytes_received)
    VALUES(
        nextval('speedtest_id_seq'),
        server_id,
        client_id,
        (_json->>'download')::double precision,
        (_json->>'upload')::double precision,
        (_json->>'ping')::double precision,
        (_json->>'bytes_sent')::bigint,
        (_json->>'bytes_received')::bigint);
    
END;
$_$;


ALTER FUNCTION public.speedtest(json) OWNER TO speedtest;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: client; Type: TABLE; Schema: public; Owner: speedtest
--

CREATE TABLE public.client (
    id integer NOT NULL,
    ip inet,
    lat double precision,
    lon double precision,
    isp character varying,
    country character varying,
    date_added timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.client OWNER TO speedtest;

--
-- Name: client_id_seq; Type: SEQUENCE; Schema: public; Owner: speedtest
--

CREATE SEQUENCE public.client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_id_seq OWNER TO speedtest;

--
-- Name: client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: speedtest
--

ALTER SEQUENCE public.client_id_seq OWNED BY public.client.id;


--
-- Name: server; Type: TABLE; Schema: public; Owner: speedtest
--

CREATE TABLE public.server (
    id bigint NOT NULL,
    url character varying,
    lat double precision,
    lon double precision,
    name character varying,
    country character varying,
    cc character varying,
    sponsor character varying,
    host character varying,
    d double precision,
    latency double precision,
    date_added timestamp with time zone DEFAULT now(),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.server OWNER TO speedtest;

--
-- Name: speedtest; Type: TABLE; Schema: public; Owner: speedtest
--

CREATE TABLE public.speedtest (
    id integer NOT NULL,
    server bigint,
    client integer NOT NULL,
    download double precision,
    upload double precision,
    ping double precision,
    bytes_sent bigint,
    bytes_received bigint,
    date_added timestamp with time zone DEFAULT now()
);


ALTER TABLE public.speedtest OWNER TO speedtest;

--
-- Name: speedtest_client_seq; Type: SEQUENCE; Schema: public; Owner: speedtest
--

CREATE SEQUENCE public.speedtest_client_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.speedtest_client_seq OWNER TO speedtest;

--
-- Name: speedtest_client_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: speedtest
--

ALTER SEQUENCE public.speedtest_client_seq OWNED BY public.speedtest.client;


--
-- Name: speedtest_id_seq; Type: SEQUENCE; Schema: public; Owner: speedtest
--

CREATE SEQUENCE public.speedtest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.speedtest_id_seq OWNER TO speedtest;

--
-- Name: speedtest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: speedtest
--

ALTER SEQUENCE public.speedtest_id_seq OWNED BY public.speedtest.id;


--
-- Name: speedtest_run; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.speedtest_run AS
 SELECT c.isp,
    c.ip AS client_ip,
    (((('('::text || c.lat) || ','::text) || c.lon) || ')'::text) AS client_coord,
    s.sponsor AS server,
    (((('('::text || s.lat) || ','::text) || s.lon) || ')'::text) AS server_coord,
    (((s.name)::text || ', '::text) || (s.cc)::text) AS server_loc,
    round((s.d)::numeric, 2) AS server_distance,
    round(((p.download / (1000000)::double precision))::numeric, 2) AS download_mbps,
    round(((p.upload / (1000000)::double precision))::numeric, 2) AS upload_mbps,
    round((p.ping)::numeric, 2) AS ping_ms,
    p.date_added
   FROM ((public.speedtest p
     LEFT JOIN public.server s ON ((p.server = s.id)))
     LEFT JOIN public.client c ON ((p.client = c.id)));


ALTER TABLE public.speedtest_run OWNER TO postgres;

--
-- Name: client id; Type: DEFAULT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.client ALTER COLUMN id SET DEFAULT nextval('public.client_id_seq'::regclass);


--
-- Name: speedtest id; Type: DEFAULT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.speedtest ALTER COLUMN id SET DEFAULT nextval('public.speedtest_id_seq'::regclass);


--
-- Name: speedtest client; Type: DEFAULT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.speedtest ALTER COLUMN client SET DEFAULT nextval('public.speedtest_client_seq'::regclass);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- Name: server server_pkey; Type: CONSTRAINT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_pkey PRIMARY KEY (id);


--
-- Name: speedtest speedtest_pkey; Type: CONSTRAINT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.speedtest
    ADD CONSTRAINT speedtest_pkey PRIMARY KEY (id);


--
-- Name: speedtest client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.speedtest
    ADD CONSTRAINT client_fkey FOREIGN KEY (client) REFERENCES public.client(id);


--
-- Name: speedtest server_fkey; Type: FK CONSTRAINT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.speedtest
    ADD CONSTRAINT server_fkey FOREIGN KEY (server) REFERENCES public.server(id);


--
-- PostgreSQL database dump complete
--

