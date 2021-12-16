import { renderHook, act } from "@testing-library/react-hooks";

import {
  VisibilityFilterOptions,
  visibilityFilterVar,
} from "../../../../state";
import { useSetVisibiltyFilter } from "..";

describe("useSetVisibilityFilter", () => {
  it("should update the active filer", () => {
    const { result } = renderHook(() => useSetVisibiltyFilter());

    const next = VisibilityFilterOptions[2];
    act(() => {
      const [setVisibilityFilter] = result.current;
      setVisibilityFilter(next);
    });

    expect(visibilityFilterVar()).toBe(next);
  });
});
