CREATE OR REPLACE FUNCTION speedtest(
	json
) RETURNS void AS $$
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
$$ LANGUAGE plpgsql;

ALTER FUNCTION speedtest(
	json
) OWNER TO speedtest;