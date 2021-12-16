import "./ErrorBanner.css";

import React from "react";
import { createPortal } from "react-dom";

export const ErrorBanner: React.FC = (props) =>
  createPortal(<div className="error-banner" {...props} />, document.body);
