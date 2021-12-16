import gql from "graphql-tag";

export const GET_PAGINATION = gql`
  query GetPagination {
    pagination @client {
      currentPage
      pageSize
      pagesCount
    }
  }
`;
