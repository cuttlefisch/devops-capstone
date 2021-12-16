import { useCallback } from "react";
import gql from "graphql-tag";

import { useRemote } from '../../../env'
import {
  Todo,
  TodoEdge,
  UpdateTodo,
  todosVar,
  useUpdateTodoMutation,
} from "../../../state";

export const UPDATE_TODO = gql`
  mutation UpdateTodo($id: ID!, $input: UpdateTodo!) {
    updateTodo(id: $id, input: $input) {
      id
      title
      completed
    }
  }
`;

const useUpdateTodoLocal = () => {
  const updateTodo = useCallback<(id: string, input: UpdateTodo) => void>(
    (id, input) => {
      const prev = todosVar();
      const { edges } = prev;

      const nextEdges = edges.reduce((acc: TodoEdge[], edge) => {
        if (edge.node.id === id)
          return acc.concat({ ...edge, node: { ...edge.node, ...(input as Todo) } });

        return acc.concat(edge);
      }, []);

      todosVar({ ...prev, edges: nextEdges });
    },
    []
  );

  return [updateTodo];
};

const useUpdateTodoRemote = () => {
  const [updateTodoMutation] = useUpdateTodoMutation();

  const updateTodo = useCallback<(id: string, input: UpdateTodo) => void>(
    (id, input) => {
      updateTodoMutation({ variables: { id, input } });
    },
    []
  );

  return [updateTodo];
};

export const useUpdateTodo = useRemote() ? useUpdateTodoRemote : useUpdateTodoLocal;
