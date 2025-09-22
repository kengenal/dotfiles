vim.g.db_ui_table_helpers = {
  postgresql = {
    Count = "SELECT COUNT(*) FROM {optional_schema}{table}",
    Select = "SELECT * FROM {optional_schema}{table}",
    Explain = "EXPLAIN ANALYZE {last_query}",
    Definition = "\\d+ {optional_schema}{table}",
  },
}


