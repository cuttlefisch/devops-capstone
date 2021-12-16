import { useEffect } from "react";

type Callback = (evt: KeyboardEvent) => void;

export const useOnEscape = (callback: Callback) => {
  useEffect(() => {
    if (typeof window !== "object") return;

    const handler = (evt: KeyboardEvent) => {
      if (evt.key === "Escape") callback(evt);
    };

    window.addEventListener("keydown", handler, {
      passive: true,
      capture: true,
    });

    return () => {
      window.removeEventListener("keydown", handler, { capture: true });
    };
  }, []);
};
