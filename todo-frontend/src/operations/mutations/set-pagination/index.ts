import { useCallback } from "react";

import { Pagination, paginationVar } from "../../../state";

export const useSetPagination = () => {
  const useSetPagination = useCallback<(filter: Pagination) => void>(
    (state) => {
      paginationVar(state);
    },
    []
  );

  return [useSetPagination];
};
