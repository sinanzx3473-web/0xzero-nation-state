import { http, createConfig } from 'wagmi';
import { sepolia } from 'wagmi/chains';
import { injected } from 'wagmi/connectors';

export const config = createConfig({
  chains: [sepolia],
  connectors: [
    injected(), // Connects to MetaMask, Rabby, Coinbase Wallet
  ],
  transports: {
    [sepolia.id]: http(),
  },
});