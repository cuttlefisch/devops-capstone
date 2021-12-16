declare global {
  namespace NodeJS {
    interface ProcessEnv {
      GATSBY_REMOTE_SCHEMA_URL?: string
    }
  }
}

export {}
