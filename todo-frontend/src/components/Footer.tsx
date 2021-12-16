import cx from "classnames";
import React, { MouseEventHandler } from "react";

import { VisibilityFilter, VisibilityFilterOptions } from "../state";

export const Footer: React.FC = ({ ...rest }) => (
  <footer className="footer" {...rest} />
);

interface FooterActiveCountProps {
  count: number;
}
export const FooterActiveCount: React.FC<FooterActiveCountProps> = ({
  count,
  ...rest
}) => {
  const isPlural = count !== 1;

  return (
    <span className="todo-count" {...rest}>
      <strong>{count}</strong> item{isPlural && "s"} left
    </span>
  );
};

export const FooterClearCompletedButton: React.FC = ({ ...rest }) => (
  <button className="clear-completed" {...rest}>
    Clear completed
  </button>
);

interface FooterVisibiltyFiltersProps {
  activeFilter: VisibilityFilter;
  setVisibilityFilter: (filter: VisibilityFilter) => void;
}

export const FooterVisibiltyFilters: React.FC<FooterVisibiltyFiltersProps> = ({
  activeFilter,
  setVisibilityFilter,
  ...rest
}) => {
  const handleFilterClick: MouseEventHandler<HTMLAnchorElement> = (evt) => {
    evt.preventDefault();
    if (!(evt.target instanceof HTMLAnchorElement)) return;

    const nextId = evt.target.href.split("/").pop();
    const next = Object.values(VisibilityFilterOptions).find(
      (o) => o.id === nextId
    );

    if (!next) return;
    setVisibilityFilter(next);
  };

  return (
    <ul className="filters" {...rest}>
      {Object.keys(VisibilityFilterOptions)
        .map((key) => VisibilityFilterOptions[key])
        .map((filter) => (
          <li key={filter.id}>
            <a
              className={cx({ selected: activeFilter.id === filter.id })}
              href={`#/${filter.id}`}
              onClick={handleFilterClick}
            >
              {filter.displayName}
            </a>
          </li>
        ))}
    </ul>
  );
};
