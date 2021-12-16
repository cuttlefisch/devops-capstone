import "./Pagination.css";

import cx from "classnames";
import React, { MouseEventHandler } from "react";
interface PaginationProps {
  currentPage: number;
  pagesCount: number;
  setPage: (nextPage: number) => void;
}

export const Pagination: React.FC<PaginationProps> = (props) => {
  const { currentPage, pagesCount, setPage, ...rest } = props;

  return (
    <nav aria-label="pagination" className="pagination-nav" {...rest}>
      <ul className="pagination">
        <PaginationItem
          disabled={currentPage <= 1}
          onClick={() => setPage(currentPage - 1)}
        >
          Previous
          <span className="visuallyhidden">page</span>
        </PaginationItem>

        {[...Array(pagesCount)].map((_, index) => (
          <PaginationItem
            active={index + 1 === currentPage}
            key={index}
            onClick={() => setPage(index + 1)}
          >
            <span className="visuallyhidden">page </span>
            {index + 1}
          </PaginationItem>
        ))}

        <PaginationItem
          disabled={pagesCount === currentPage}
          onClick={() => setPage(currentPage + 1)}
        >
          Next
          <span className="visuallyhidden">page</span>
        </PaginationItem>
      </ul>
    </nav>
  );
};

interface PaginationItemProps {
  active?: boolean;
  disabled?: boolean;
  onClick: MouseEventHandler<HTMLButtonElement>;
}
const PaginationItem: React.FC<PaginationItemProps> = (props) => {
  const { active, children, disabled = false, onClick, ...rest } = props;

  return (
    <li
      className={cx({
        pagination__item: true,
        "pagination__item--active": active,
      })}
      {...rest}
    >
      <button
        disabled={disabled}
        className="pagination__link"
        onClick={onClick}
      >
        {children}
      </button>
    </li>
  );
};
