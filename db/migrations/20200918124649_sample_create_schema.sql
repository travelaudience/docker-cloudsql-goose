-- +goose Up
-- +goose StatementBegin
CREATE SCHEMA goose_demo_schema AUTHORIZATION postgres;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP SCHEMA goose_demo_schema;
-- +goose StatementEnd
