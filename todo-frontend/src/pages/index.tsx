import React, { useCallback, useEffect, useMemo } from "react";

import {
  useCreateTodo,
  useDeleteTodo,
  useSetPagination,
  useSetVisibiltyFilter,
  useUpdateTodo,
} from "../operations";
import {
  TodoEdge,
  VisibilityFilter,
  VisibilityFilterOptions,
  useGetPaginationQuery,
  useGetTodosQuery,
  useGetVisibilityFilterQuery,
} from "../state";

import { ErrorBanner } from "../components/ErrorBanner";
import { Header, HeaderTitle, HeaderNewTodoInput } from "../components/Header";
import { Loading } from "../components/Loading";
import {
  Footer,
  FooterActiveCount,
  FooterVisibiltyFilters,
} from "../components/Footer";
import { Main } from "../components/Main";
import { Pagination } from "../components/Pagination";
import { TodoList, TodoListItem } from "../components/TodoList";

const IndexRoute: React.FC = () => {
  const { data: todosData, loading, error } = useGetTodosQuery();
  const [createTodo] = useCreateTodo();
  const [deleteTodo] = useDeleteTodo();
  const [updateTodo] = useUpdateTodo();

  const { data: paginationData } = useGetPaginationQuery();
  const [setPagination] = useSetPagination();

  const { data: visibilityFilterData } = useGetVisibilityFilterQuery();
  const [setVisibilityFilter] = useSetVisibiltyFilter();

  const [completed, active] = useMemo(() => {
    const edges = todosData?.todos?.edges || [];

    return edges.reduce<[TodoEdge[], TodoEdge[]]>(
      ([a, b], edge) => {
        return edge.node.completed ? [[...a, edge], b] : [a, [...b, edge]];
      },
      [[], []]
    );
  }, [todosData]);

  const activeFilter = useMemo<VisibilityFilter>(() => {
    return (
      visibilityFilterData?.visibilityFilter ||
      VisibilityFilterOptions["SHOW_ALL"]
    );
  }, [visibilityFilterData]);

  const filtered = useMemo<TodoEdge[]>(() => {
    if (activeFilter.id === VisibilityFilterOptions["SHOW_ACTIVE"].id) {
      return active;
    }

    if (activeFilter.id === VisibilityFilterOptions["SHOW_COMPLETED"].id) {
      return completed;
    }

    return todosData?.todos?.edges || [];
  }, [activeFilter, completed, active]);

  const hasSelectedItems = filtered.length > 0;

  const { currentPage, pageSize, pagesCount } = paginationData!.pagination;
  useEffect(() => {
    if (!paginationData) return;

    const count = filtered.length;
    const { currentPage: prevCurrentPage } = paginationData.pagination;

    const nextPagesCount = Math.ceil(count / pageSize);
    const nextCurrentPage =
      pagesCount > 0 && prevCurrentPage > nextPagesCount
        ? nextPagesCount
        : currentPage;

    setPagination({
      ...paginationData.pagination,
      currentPage: nextCurrentPage > 0 ? nextCurrentPage : 1,
      pagesCount: nextPagesCount > 0 ? nextPagesCount : 1,
    });
  }, [filtered.length, paginationData]);

  const setPage = useCallback<(nextPage: number) => void>((nextPage) => {
    if (!paginationData) return;
    setPagination({
      ...paginationData.pagination,
      currentPage: nextPage,
    });
  }, []);

  return (
    <>
      <div className="todoapp">
        <Header>
          <HeaderTitle />
          <HeaderNewTodoInput createTodo={createTodo} />
        </Header>

        {error && <ErrorBanner>Unexpected Error</ErrorBanner>}
        {loading && <Loading />}

        {hasSelectedItems && (
          <Main>
            {/*
            {completed.length > 0 && (
              <>
                <input id="toggle-all" className="toggle-all" type="checkbox" />
                <label htmlFor="toggle-all">Mark all as complete</label>
              </>
            )}
            */}

            <TodoList>
              {filtered
                .slice((currentPage - 1) * pageSize, currentPage * pageSize)
                .map(({ node }) => (
                  <TodoListItem
                    key={node.id}
                    todo={node}
                    onDelete={deleteTodo}
                    onUpdate={updateTodo}
                  />
                ))}
            </TodoList>

            {pagesCount > 1 && (
              <Pagination
                currentPage={currentPage}
                pagesCount={pagesCount}
                setPage={setPage}
              />
            )}
          </Main>
        )}

        <Footer>
          {active.length > 0 && <FooterActiveCount count={active.length} />}

          <FooterVisibiltyFilters
            activeFilter={activeFilter}
            setVisibilityFilter={setVisibilityFilter}
          />

          {/*
          {completed.length > 0 && <FooterClearCompletedButton />}
          */}
        </Footer>
      </div>

      <footer className="info">
        <p>Double-click to edit a todo</p>
        <p>
          Template by <a href="http://sindresorhus.com">Sindre Sorhus</a>
        </p>
        <p>
          Part of <a href="http://todomvc.com">TodoMVC</a>
        </p>
      </footer>
    </>
  );
};

export default IndexRoute;
