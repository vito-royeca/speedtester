CREATE OR REPLACE FUNCTION speedtest(
	character varying,
    character varying,
    character varying,
    character varying,
    double precision,
    double precision,
    double precision,
    double precision
) RETURNS void AS $$
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
$$ LANGUAGE plpgsql;

ALTER FUNCTION speedtest(
	character varying,
    character varying,
    character varying,
    character varying,
    double precision,
    double precision,
    double precision,
    double precision
) OWNER TO speedtest;