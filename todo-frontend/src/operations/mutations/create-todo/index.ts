import { useCallback } from "react";
import gql from "graphql-tag";
import { v4 as uuid } from "uuid";

import { useRemote } from '../../../env'
import {
  NewTodo,
  TodoEdge,
  todosVar,
  useCreateTodoMutation
} from "../../../state";

export const CREATE_TODO = gql`
  mutation CreateTodo($title: String!) {
    createTodo(input: { title: $title }) {
      id
      title
    }
  }
`;

const useCreateTodoLocal = () => {
  const createTodo = useCallback<(input: NewTodo) => void>((input) => {
    const prev = todosVar();

    const id = uuid();
    const next: TodoEdge = {
      cursor: id,
      node: { ...input, id, completed: false },
    };

    todosVar({ ...prev, edges: prev.edges.concat(next) });
  }, []);

  return [createTodo];
};

const useCreateTodoRemote = () => {
  const [createTodoMutation] = useCreateTodoMutation();

  const createTodo = useCallback<(input: NewTodo) => void>((input) => {
      createTodoMutation({
        refetchQueries: ['GetTodos'],
        variables: { title: input.title },
      });
  }, []);

  return [createTodo];
};

export const useCreateTodo = useRemote() ? useCreateTodoRemote : useCreateTodoLocal;
