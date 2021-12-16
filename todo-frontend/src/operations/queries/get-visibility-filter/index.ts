import gql from "graphql-tag";

export const GET_VISIBILITY_FILTER = gql`
  query GetVisibilityFilter {
    visibilityFilter @client {
      id
      displayName
    }
  }
`;
