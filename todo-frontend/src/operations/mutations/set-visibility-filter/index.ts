import { useCallback } from "react";

import { VisibilityFilter, visibilityFilterVar } from "../../../state";

export const useSetVisibiltyFilter = () => {
  const useSetVisibiltyFilter = useCallback<(filter: VisibilityFilter) => void>(
    (filter) => {
      visibilityFilterVar(filter);
    },
    []
  );

  return [useSetVisibiltyFilter];
};
