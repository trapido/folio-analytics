-- This table contains holdings statements for supplements with their
-- associated public/staff only notes; regular holdings statements and
-- holdings statements for indexes are in separate tables. Here note is a public note.
DROP TABLE IF EXISTS holdings_statements_supplements;
CREATE TABLE holdings_statements_supplements AS
WITH holdings AS (
    SELECT 
    h.instanceid AS instance_id,
    h.id AS holdings_id,
    jsonb_extract_path_text(h.jsonb, 'hrid') AS holdings_hrid,
    jsonb_extract_path_text(hs.jsonb, 'statement') AS "statement",
    jsonb_extract_path_text(hs.jsonb, 'note') AS public_note,
    jsonb_extract_path_text(hs.jsonb, 'staffNote') AS staff_note,
    hs.ordinality AS statement_ordinality
    FROM folio_inventory.holdings_record AS h
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(h.jsonb, 'holdingsStatementsForSupplements'))
    WITH ORDINALITY AS hs (jsonb))
SELECT    
    hs.instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,   
    hs.holdings_id,
    hs.holdings_hrid,
    hs."statement",
    hs.public_note,
    hs.staff_note, 
    hs.statement_ordinality
    FROM holdings AS hs
    LEFT JOIN folio_inventory.instance AS i ON hs.instance_id = i.id
;

CREATE INDEX ON holdings_statements_for_supplements (instance_id);

CREATE INDEX ON holdings_statements_for_supplements (instance_hrid);

CREATE INDEX ON holdings_statements_for_supplements (holdings_id);

CREATE INDEX ON holdings_statements_for_supplements (holdings_hrid);

CREATE INDEX ON holdings_statements_for_supplements ("statement");

CREATE INDEX ON holdings_statements_for_supplements (public_note);

CREATE INDEX ON holdings_statements_for_supplements (staff_note);

CREATE INDEX ON holdings_statements_for_supplements (statement_ordinality);

VACUUM ANALYZE holdings_statements_for_supplements;
