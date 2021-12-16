import React, {
  ChangeEventHandler,
  KeyboardEventHandler,
  MouseEventHandler,
  useState,
} from "react";
import cx from "classnames";

import { useOnEscape } from "../hooks";
import { Todo, UpdateTodo } from "../state";

export const TodoList: React.FC = (props) => (
  <ul className="todo-list" {...props} />
);

interface TodoListItemProps {
  todo: Todo;
  onDelete: (id: string) => void;
  onUpdate: (id: string, input: UpdateTodo) => void;
}

export const TodoListItem: React.FC<TodoListItemProps> = (props) => {
  const { children: _, onDelete, onUpdate, todo, ...rest } = props;

  const [editing, setEditing] = useState<boolean>(false);

  useOnEscape(() => {
    setEditing(false);
  });

  const handleDoubleClick: MouseEventHandler<HTMLLIElement> = () => {
    setEditing(true);
  };

  const handleToggle: ChangeEventHandler<HTMLInputElement> = () => {
    const input = { ...todo, completed: !todo.completed };
    save(input);
  };

  const save = (input: UpdateTodo) => {
    onUpdate(todo.id, { completed: input.completed, title: input.title });
    setEditing(false);
  };

  return (
    <li
      {...rest}
      className={cx({ completed: todo.completed, editing })}
      onDoubleClick={handleDoubleClick}
    >
      {editing ? (
        <TodoListItemEditInput todo={todo} onSubmit={save} />
      ) : (
        <div className="view">
          <input
            className="toggle"
            type="checkbox"
            checked={todo.completed}
            onChange={handleToggle}
          />
          <label>{todo.title}</label>
          <button className="destroy" onClick={() => onDelete(todo.id)} />
        </div>
      )}
    </li>
  );
};

interface TodoListItemEditInputProps extends Pick<TodoListItemProps, "todo"> {
  onSubmit: (input: UpdateTodo) => void;
}

export const TodoListItemEditInput: React.FC<TodoListItemEditInputProps> = (
  props
) => {
  const { todo, onSubmit, ...rest } = props;
  const [value, setValue] = useState<Todo["title"]>(todo.title);

  const handleChange: ChangeEventHandler<HTMLInputElement> = (evt) => {
    setValue(evt.target.value);
  };

  const save: KeyboardEventHandler<HTMLInputElement> = (evt) => {
    if (evt.key !== "Enter") return;

    if (!(evt.target instanceof HTMLInputElement)) return;

    const nextValue = evt.target.value.trim();
    const input = { ...todo, title: nextValue };
    onSubmit(input);
  };

  /* eslint-disable jsx-a11y/no-autofocus */
  return (
    <input
      {...rest}
      autoFocus
      className="edit"
      onChange={handleChange}
      onKeyDown={save}
      type="text"
      value={value}
    />
  );
  /* eslint-enable jsx-a11y/no-autofocus */
};
