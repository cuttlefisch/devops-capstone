import React, {
  ChangeEventHandler,
  KeyboardEventHandler,
  useState,
} from "react";

import { NewTodo } from "../state";

export const Header: React.FC = (props) => (
  <header className="header" {...props} />
);

export const HeaderTitle: React.FC = () => <h1>todos</h1>;

interface HeaderNewTodoInputProps {
  createTodo: (input: NewTodo) => void;
}

export const HeaderNewTodoInput: React.FC<HeaderNewTodoInputProps> = ({
  createTodo,
  ...rest
}) => {
  const [value, setValue] = useState<string>("");

  const handleChange: ChangeEventHandler<HTMLInputElement> = (evt) => {
    setValue(evt.target.value);
  };

  const save: KeyboardEventHandler<HTMLInputElement> = (evt) => {
    if (evt.key !== "Enter") return;
    if (!(evt.target instanceof HTMLInputElement)) return;

    const title = evt.target.value.trim();
    if(title === '') return;

    createTodo({ title });
    setValue("");
  };
  return (
    <input
      {...rest}
      className="new-todo"
      onChange={handleChange}
      onKeyDown={save}
      placeholder="What needs to be done?"
      value={value}
    />
  );
};
