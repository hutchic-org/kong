return {
  postgres = {
    up = [[
      CREATE TABLE IF NOT EXISTS "clustering_data_planes" (
        id             UUID PRIMARY KEY,
        hostname       TEXT NOT NULL,
        ip             TEXT NOT NULL,
        last_seen      TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'),
        config_hash    TEXT NOT NULL
      );

      DO $$
      BEGIN
        ALTER TABLE IF EXISTS ONLY "routes" ADD "request_buffering" BOOLEAN;
      EXCEPTION WHEN DUPLICATE_COLUMN THEN
        -- Do nothing, accept existing state
      END;
      $$;

      DO $$
      BEGIN
        ALTER TABLE IF EXISTS ONLY "routes" ADD "response_buffering" BOOLEAN;
      EXCEPTION WHEN DUPLICATE_COLUMN THEN
        -- Do nothing, accept existing state
      END;
      $$;
    ]],
  },
  cassandra = {
    up = [[
      CREATE TABLE IF NOT EXISTS clustering_data_planes(
        id uuid,
        hostname text,
        ip text,
        last_seen timestamp,
        config_hash text,
        PRIMARY KEY (id)
      );

      ALTER TABLE routes ADD request_buffering boolean;
      ALTER TABLE routes ADD response_buffering boolean;
    ]],
  }
}