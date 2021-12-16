import { InMemoryCache, ReactiveVar, makeVar } from "@apollo/client";
import { v4 as uuid } from "uuid";

import { useRemote } from '../env'
import {
  Pagination,
  Todo,
  TodoConnection,
  VisibilityFilter,
} from "./generated";

export const cache: InMemoryCache = new InMemoryCache({
  typePolicies: {
    Query: {
      fields: {
        ...(!useRemote() && {
          todos: {
            read: () => todosVar(),
          },
        }),
        pagination: {
          read: () => paginationVar(),
        },
        visibilityFilter: {
          read: () => visibilityFilterVar(),
        },
      },
    },
  },
});

export const paginationVar = makeVar<Pagination>({
  currentPage: 1,
  pageSize: 10,
  pagesCount: 0,
});

const initialTodos: Todo[] = [...Array(50)].map((_, index) => ({
  completed: (index + 1) % 3 === 0,
  id: uuid(),
  title: `todo ${index + 1}`,
}));

export const todosVar: ReactiveVar<TodoConnection> = makeVar<TodoConnection>({
  edges: initialTodos.map((t) => ({ cursor: t.id, node: t })),
  pageInfo: {
    startCursor: initialTodos[0].id,
    endCursor: initialTodos[initialTodos.length - 1].id,
    hasNextPage: false,
  },
  totalCount: initialTodos.length,
});

export const VisibilityFilterOptions: { [filter: string]: VisibilityFilter } = {
  SHOW_ALL: {
    id: "show_all",
    displayName: "All",
  },
  SHOW_COMPLETED: {
    id: "show_completed",
    displayName: "Completed",
  },
  SHOW_ACTIVE: {
    id: "show_active",
    displayName: "Active",
  },
};

export const visibilityFilterVar = makeVar<VisibilityFilter>(
  VisibilityFilterOptions.SHOW_ALL
);
