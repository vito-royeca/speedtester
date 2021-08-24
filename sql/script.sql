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
-- Name: speedtest(character varying, character varying, character varying, character varying, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: speedtest
--

CREATE FUNCTION public.speedtest(character varying, character varying, character varying, character varying, double precision, double precision, double precision, double precision) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _isp ALIAS FOR $1;
    _ip_address ALIAS FOR $2;
    _server ALIAS FOR $3;
    _server_location ALIAS FOR $4;
    _server_distance_km ALIAS FOR $5;
    _server_ping_ms ALIAS FOR $6;
    _download_mbps ALIAS FOR $7;
    _upload_mbps ALIAS FOR $8;
BEGIN
    INSERT INTO speedtest_run(
        isp,
        ip_address,
        server,
        server_location,
        server_distance_km,
        server_ping_ms,
        download_mbps,
        upload_mbps
    ) VALUES(
        _isp,
        _ip_address::cidr,
        _server,
        _server_location,
        _server_distance_km,
        _server_ping_ms,
        _download_mbps,
        _upload_mbps
    );
END;
$_$;


ALTER FUNCTION public.speedtest(character varying, character varying, character varying, character varying, double precision, double precision, double precision, double precision) OWNER TO speedtest;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: speedtest_run; Type: TABLE; Schema: public; Owner: speedtest
--

CREATE TABLE public.speedtest_run (
    id integer NOT NULL,
    isp character varying,
    ip_address cidr,
    server_location character varying,
    server_distance_km double precision,
    download_mbps double precision,
    upload_mbps double precision,
    date_added timestamp with time zone DEFAULT now(),
    server character varying,
    server_ping_ms double precision
);


ALTER TABLE public.speedtest_run OWNER TO speedtest;

--
-- Name: speedtest_run_id_seq; Type: SEQUENCE; Schema: public; Owner: speedtest
--

CREATE SEQUENCE public.speedtest_run_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.speedtest_run_id_seq OWNER TO speedtest;

--
-- Name: speedtest_run_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: speedtest
--

ALTER SEQUENCE public.speedtest_run_id_seq OWNED BY public.speedtest_run.id;


--
-- Name: speedtest_run id; Type: DEFAULT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.speedtest_run ALTER COLUMN id SET DEFAULT nextval('public.speedtest_run_id_seq'::regclass);


--
-- Name: speedtest_run speedtest_run_pkey; Type: CONSTRAINT; Schema: public; Owner: speedtest
--

ALTER TABLE ONLY public.speedtest_run
    ADD CONSTRAINT speedtest_run_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

