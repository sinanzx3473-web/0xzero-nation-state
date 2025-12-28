import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.tsx';
import './index.css';

// 1. Import Dependencies
import { WagmiProvider, createConfig, http } from 'wagmi';
import { sepolia } from 'wagmi/chains';
import { injected } from 'wagmi/connectors';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

// 2. Define the Engine Config DIRECTLY here (Safest Method)
const config = createConfig({
  chains: [sepolia],
  connectors: [
    injected(), // This finds MetaMask/Rabby automatically
  ],
  transports: {
    [sepolia.id]: http(),
  },
});

// 3. Initialize Query Client
const queryClient = new QueryClient();

// 4. Render the App wrapped in the Providers
ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <App />
      </QueryClientProvider>
    </WagmiProvider>
  </React.StrictMode>,
);