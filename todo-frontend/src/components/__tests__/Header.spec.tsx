import React from "react";
import { render, screen } from "@testing-library/react";

import { Header, HeaderTitle, HeaderNewTodoInput } from "../Header";

describe("Header", () => {
  it("should have a heading", () => {
    const createTodo = jest.fn();

    render(
      <Header>
        <HeaderTitle />
        <HeaderNewTodoInput createTodo={createTodo} />
      </Header>
    );
    const heading = screen.getByRole("heading", { level: 1 });

    expect(heading).toHaveTextContent("todos");
  });
});
