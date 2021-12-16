import React, { ReactNode } from "react";
import { ApolloProvider } from "@apollo/client";
import { client } from "./client";

interface Props {
  element: ReactNode;
  pathname: string;
}

export const wrapRootElement: React.FC<Props> = ({ element }) => (
  <ApolloProvider client={client}>{element}</ApolloProvider>
);
