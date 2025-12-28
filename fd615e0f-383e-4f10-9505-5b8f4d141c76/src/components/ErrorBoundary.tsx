import React, { Component, ErrorInfo, ReactNode } from "react";

interface Props { children: ReactNode; }
interface State { hasError: boolean; }

export class ErrorBoundary extends Component<Props, State> {
  public state: State = { hasError: false };

  public static getDerivedStateFromError(_: Error): State { return { hasError: true }; }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error("Uncaught error:", error, errorInfo);
  }

  public render() {
    if (this.state.hasError) {
      return (
        <div className="h-screen w-full bg-black flex flex-col items-center justify-center text-[#00ff41] font-mono p-4">
          <h1 className="text-4xl font-bold mb-4">/// SYSTEM FAILURE</h1>
          <p>CRITICAL ERROR DETECTED. REBOOTING INTERFACE...</p>
          <button onClick={() => window.location.reload()} className="mt-8 border border-[#00ff41] px-6 py-2 hover:bg-[#00ff41] hover:text-black transition-colors uppercase">[FORCE RESTART]</button>
        </div>
      );
    }
    return this.props.children;
  }
}
