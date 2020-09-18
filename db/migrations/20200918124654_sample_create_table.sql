-- +goose Up
-- +goose StatementBegin
CREATE TABLE goose_demo_schema.demo_table
(
  start_ts           timestamp NOT NULL,
  end_ts             timestamp NOT NULL,

  account_id         integer   NOT NULL,
  CONSTRAINT account_id UNIQUE (account_id)
);
-- OWNER
ALTER TABLE goose_demo_schema.demo_table
  OWNER TO postgres;
-- GRANT/REVOKE
REVOKE ALL ON TABLE goose_demo_schema.demo_table FROM PUBLIC;
GRANT ALL ON TABLE goose_demo_schema.demo_table TO postgres;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE goose_demo_schema.demo_table;

-- +goose StatementEnd
