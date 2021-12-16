import gql from "graphql-tag";

export const GET_TODOS = gql`
  query GetTodos {
    todos {
      edges {
        cursor
        node {
          id
          title
          completed
        }
      }
      pageInfo {
        endCursor
        hasNextPage
        startCursor
      }
    }
  }
`;
