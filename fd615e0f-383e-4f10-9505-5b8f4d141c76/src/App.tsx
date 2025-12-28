import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Shield, Wallet, Scale, Globe, Cpu, Activity, Lock, Terminal, User, X, Server, Upload, Zap, ArrowRight, AlertCircle, Code, Radio, Users } from 'lucide-react';
import { useAccount, useConnect, useDisconnect, useWriteContract, useReadContract, useWaitForTransactionReceipt } from 'wagmi';
import { injected } from 'wagmi/connectors';
import { formatEther } from 'viem';

// --- CONTRACT CONFIGURATION (Safe Mode) ---
const CONTRACTS = {
  citizenship: {
    address: "0x4c6d91848b1aed3efb8de304ec1270dda1ca384c" as `0x${string}`,
    abi: [
      { type: 'function', name: 'mintCitizenship', inputs: [], outputs: [] },
      { type: 'function', name: 'getCitizenId', inputs: [{ name: 'holder', type: 'address' }], outputs: [{ name: '', type: 'uint256' }], stateMutability: 'view' }
    ]
  },
  zeroToken: {
    address: "0x333f8b477A07742a19364e67D23b60A2DC972730" as `0x${string}`,
    abi: [
      { type: 'function', name: 'claimTokens', inputs: [], outputs: [] },
      { type: 'function', name: 'balanceOf', inputs: [{ name: 'account', type: 'address' }], outputs: [{ name: '', type: 'uint256' }], stateMutability: 'view' }
    ]
  }
};

// --- TERMINAL ULTRA STYLES ---
const brutalistStyles = {
  container: "min-h-screen w-full bg-[#020202] text-[#e0e0e0] font-mono selection:bg-[#00ff41] selection:text-black relative overflow-x-hidden",
  grid: "fixed inset-0 bg-[linear-gradient(to_right,#111_1px,transparent_1px),linear-gradient(to_bottom,#111_1px,transparent_1px)] bg-[size:4rem_4rem] [mask-image:radial-gradient(ellipse_60%_50%_at_50%_0%,#000_70%,transparent_100%)] pointer-events-none opacity-20 z-0",
  h1: "text-5xl md:text-8xl font-bold tracking-tighter mb-6 leading-tight text-white drop-shadow-[0_0_15px_rgba(0,255,65,0.3)]",
  button: "bg-[#00ff41] text-black px-8 py-4 font-bold tracking-widest hover:bg-white hover:shadow-[0_0_20px_rgba(255,255,255,0.5)] transition-all uppercase text-sm cursor-pointer z-50 relative clip-path-polygon-[0_0,100%_0,100%_80%,90%_100%,0_100%]",
  card: "border border-[#1a1a1a] bg-[#050505]/90 backdrop-blur-md p-8 hover:border-[#00ff41] transition-all duration-300 relative group cursor-pointer hover:shadow-[0_0_30px_rgba(0,255,65,0.15)] hover:-translate-y-1"
};

// --- VISUAL COMPONENTS ---
const Scanline = () => (
  <div className="fixed inset-0 pointer-events-none z-[999] bg-[linear-gradient(rgba(18,16,16,0)_50%,rgba(0,0,0,0.1)_50%),linear-gradient(90deg,rgba(255,0,0,0.03),rgba(0,255,0,0.01),rgba(0,0,255,0.03))] bg-[length:100%_2px,3px_100%] opacity-20" />
);

const MatrixRain = () => (
  <div className="fixed inset-0 overflow-hidden opacity-20 pointer-events-none z-0">
    <div className="flex justify-around text-[#00ff41] text-xs">
      {Array.from({ length: 20 }).map((_, i) => (
        <motion.div key={i} initial={{ y: -100 }} animate={{ y: "100vh" }} transition={{ duration: Math.random() * 5 + 5, repeat: Infinity, ease: "linear", delay: Math.random() * 5 }}>
          {Array.from({ length: 15 }).map((_, j) => <div key={j} className="my-2">{String.fromCharCode(0x30A0 + Math.random() * 96)}</div>)}
        </motion.div>
      ))}
    </div>
  </div>
);

const Ticker = () => (
  <div className="fixed top-0 w-full bg-[#00ff41] text-black text-xs font-bold py-1 z-50 overflow-hidden whitespace-nowrap">
    <motion.div animate={{ x: [0, -1000] }} transition={{ repeat: Infinity, duration: 20, ease: "linear" }} className="inline-block">
      /// LATEST BLOCK: #892,102 &nbsp;&nbsp;&nbsp; /// SYSTEM STATUS: NOMINAL &nbsp;&nbsp;&nbsp; /// TPS: 14,205 &nbsp;&nbsp;&nbsp; /// ACTIVE AGENTS: 8,492 &nbsp;&nbsp;&nbsp; /// TOTAL VALUE SECURED: $4.2B &nbsp;&nbsp;&nbsp; /// LATEST BLOCK: #892,102 &nbsp;&nbsp;&nbsp; /// SYSTEM STATUS: NOMINAL &nbsp;&nbsp;&nbsp; /// TPS: 14,205 &nbsp;&nbsp;&nbsp; /// ACTIVE AGENTS: 8,492
    </motion.div>
  </div>
);

// --- COMPUTE MODAL (FIXED) ---
const ComputeModal = ({ onClose }: { onClose: () => void }) => {
    const { connect, connectors, error } = useConnect();
    const { isConnected } = useAccount();
    const { writeContract } = useWriteContract();

    const handleAction = () => {
        if (!isConnected) {
            const targetConnector = connectors[0];
            if (!targetConnector) {
                alert("ERROR: No Wallet Connector found. Please ensure MetaMask is installed.");
                return;
            }
            connect({ connector: targetConnector });
        } else {
            writeContract({ ...CONTRACTS.zeroToken, functionName: 'claimTokens' });
        }
    };

    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/80 backdrop-blur-sm p-4">
            <motion.div initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} className="w-full max-w-2xl border border-[#333] bg-[#0a0a0a] p-8 shadow-2xl relative">
                <button onClick={onClose} className="absolute top-4 right-4 text-gray-500 hover:text-white"><X /></button>
                <h2 className="text-2xl font-bold mb-1 flex items-center gap-2"><Server className="text-[#00ff41]" /> RENT COMPUTE</h2>
                {error && <div className="text-red-500 text-xs mb-4 border border-red-500 p-2">CONNECTION ERROR: {error.message}</div>}
                
                <p className="text-xs text-gray-500 mb-8">MARKETPLACE / GPU / SPOT_INSTANCES</p>
                <div className="grid grid-cols-3 gap-4 mb-8">
                    {[1, 10, 100].map(num => (
                        <div key={num} className="border border-[#333] p-4 hover:border-[#00ff41] cursor-pointer hover:bg-[#111] transition-all">
                            <div className="text-3xl font-bold text-white mb-2">{num}x</div>
                            <div className="text-xs text-gray-400">NVIDIA H100</div>
                            <div className="text-[#00ff41] text-xs mt-2">{num * 4.5} ZERO/hr</div>
                        </div>
                    ))}
                </div>
                
                <button onClick={handleAction} className="w-full bg-[#00ff41] text-black font-bold py-4 hover:bg-white transition-colors uppercase shadow-[0_0_15px_rgba(0,255,65,0.4)]">
                    {isConnected ? "INITIATE STREAM" : "CONNECT WALLET"}
                </button>
            </motion.div>
        </div>
    );
};

// --- DASHBOARD COMPONENT ---
const Dashboard = ({ onBack }: { onBack: () => void }) => {
    const { address } = useAccount();
    const { writeContract, data: hash, isPending } = useWriteContract();
    const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash });
    const { data: citizenId } = useReadContract({ ...CONTRACTS.citizenship, functionName: 'getCitizenId', args: [address] });
    const { data: zeroBalance } = useReadContract({ ...CONTRACTS.zeroToken, functionName: 'balanceOf', args: [address] });
    
    const [showCompute, setShowCompute] = useState(false);

    const handleClaim = () => {
        writeContract({ ...CONTRACTS.zeroToken, functionName: 'claimTokens' });
    };

    return (
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="p-6 md:p-12 min-h-screen pt-24 relative z-10">
            {showCompute && <ComputeModal onClose={() => setShowCompute(false)} />}
            
            <button onClick={onBack} className="fixed top-4 left-4 text-xs text-gray-500 hover:text-white z-50 flex items-center gap-2">
                <ArrowRight className="w-4 h-4 rotate-180" /> EXIT CONSOLE
            </button>

            <div className="max-w-7xl mx-auto">
                <header className="flex justify-between items-center mb-12 border-b border-[#333] pb-6">
                    <div>
                        <h1 className="text-3xl font-bold text-white mb-1 drop-shadow-[0_0_10px_rgba(255,255,255,0.3)]">SOVEREIGN CONSOLE</h1>
                        <p className="text-[#00ff41] text-xs tracking-widest drop-shadow-[0_0_5px_rgba(0,255,65,0.5)]">
                            CITIZEN ID: {citizenId ? `#${citizenId.toString()}` : "UNREGISTERED"}
                        </p>
                    </div>
                    <div className="flex gap-4 text-xs font-mono text-gray-400">
                        <div className="flex items-center gap-2"><Activity className="w-4 h-4 text-[#00ff41]" /> NETWORK: SEPOLIA</div>
                        <div className="flex items-center gap-2"><Terminal className="w-4 h-4 text-[#00ff41]" /> {address?.slice(0,6)}...{address?.slice(-4)}</div>
                    </div>
                </header>
                
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    {/* IDENTITY CARD */}
                    <div className="lg:col-span-1 space-y-6">
                        <div className="bg-[#0a0a0a] border border-[#333] p-6 hover:border-[#00ff41] transition-colors relative overflow-hidden">
                            <div className="flex items-center gap-4 mb-6">
                                <div className="w-16 h-16 bg-[#111] border border-[#333] flex items-center justify-center">
                                    <User className="text-[#00ff41]" />
                                </div>
                                <div>
                                    <div className="text-white font-bold">OPERATOR</div>
                                    <div className="text-xs text-gray-500">{citizenId ? "VERIFIED CITIZEN" : "GUEST ACCESS"}</div>
                                </div>
                            </div>
                            <div className="space-y-3 text-xs font-mono border-t border-[#333] pt-4">
                                <div className="flex justify-between">
                                    <span className="text-gray-500">ZERO BALANCE</span>
                                    <span className="text-[#00ff41] font-bold text-lg">
                                        {zeroBalance ? parseFloat(formatEther(zeroBalance as bigint)).toFixed(2) : "0.00"}
                                    </span>
                                </div>
                                <button 
                                    onClick={handleClaim}
                                    disabled={isPending || isConfirming}
                                    className="w-full mt-4 bg-[#111] border border-[#333] text-[#00ff41] py-2 hover:bg-[#00ff41] hover:text-black transition-colors uppercase text-xs font-bold"
                                >
                                    {isPending ? "SIGNING..." : isConfirming ? "MINING..." : "CLAIM FAUCET (1000 ZERO)"}
                                </button>
                                {isSuccess && <div className="text-[#00ff41] text-[10px] mt-2 text-center">TRANSACTION CONFIRMED</div>}
                            </div>
                        </div>
                    </div>

                    {/* MARKETPLACE */}
                    <div className="lg:col-span-2 space-y-6">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div onClick={() => setShowCompute(true)} className={brutalistStyles.card}>
                                <Cpu className="w-8 h-8 text-white group-hover:text-[#00ff41] mb-4" />
                                <h3 className="font-bold text-white">RENT COMPUTE</h3>
                                <p className="text-xs text-gray-500 mt-2">Access H100 Cluster. Requires ZERO.</p>
                            </div>
                            <div className={brutalistStyles.card}>
                                <Globe className="w-8 h-8 text-white group-hover:text-[#00ff41] mb-4" />
                                <h3 className="font-bold text-white">DEPLOY AGENT</h3>
                                <p className="text-xs text-gray-500 mt-2">Upload Docker container to Jurisdiction.</p>
                            </div>
                        </div>

                        {/* LIVE NETWORK STATE */}
                        <div className="border border-[#333] bg-[#0a0a0a] p-6 relative overflow-hidden">
                            <div className="flex items-center gap-2 mb-4 border-b border-[#333] pb-2">
                                <Activity className="w-4 h-4 text-[#00ff41]" />
                                <span className="text-xs font-bold text-white">LIVE NETWORK STATE</span>
                            </div>
                            <div className="flex items-center gap-8">
                                <div className="flex gap-2">
                                    {[1043, 1044, 1045].map((block, i) => (
                                        <motion.div 
                                            key={block}
                                            initial={{ opacity: 0, x: 20 }}
                                            animate={{ opacity: 1, x: 0 }}
                                            transition={{ delay: i * 0.2 }}
                                            className="w-16 h-16 bg-[#111] border border-[#333] flex flex-col items-center justify-center"
                                        >
                                            <span className="text-[#00ff41] font-bold text-xs">#{block}</span>
                                            <span className="text-[10px] text-gray-600">VALID</span>
                                        </motion.div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </motion.div>
    )
}

// --- MAIN APP ---
export default function App() {
  const { isConnected, address } = useAccount();
  const { connect, connectors } = useConnect();
  const { writeContract, isPending, data: hash } = useWriteContract();
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash });
  
  const [currentView, setCurrentView] = useState('landing');

  const handleMint = () => {
      if (!isConnected) {
          const connector = connectors[0];
          if (connector) connect({ connector });
          else alert("Please install MetaMask!");
          return;
      }
      writeContract({ ...CONTRACTS.citizenship, functionName: 'mintCitizenship' });
  };

  useEffect(() => {
      if (isSuccess) {
          setTimeout(() => setCurrentView('dashboard'), 2000); 
      }
  }, [isSuccess]);

  if (currentView === 'dashboard') return <Dashboard onBack={() => setCurrentView('landing')} />;

  return (
    <div className={brutalistStyles.container}>
      <Ticker />
      <Scanline />
      <div className={brutalistStyles.grid} />
      <MatrixRain />
      
      <section className="relative min-h-screen flex flex-col items-center justify-center px-6 md:px-20 z-10 border-b border-[#333] text-center pt-20">
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.8 }}>
          <div className="inline-flex items-center gap-2 border border-[#00ff41] text-[#00ff41] px-4 py-1 mb-8 text-xs font-bold tracking-[0.2em] bg-[#00ff41]/10 rounded-full shadow-[0_0_15px_rgba(0,255,65,0.2)]">
            <Globe className="w-3 h-3" /> JURISDICTION: 0xZERO
          </div>
          <h1 className={brutalistStyles.h1}>
            THE FIRST NATION-STATE<br />
            {/* FIXED: Removed dot here */}
            <span className="text-transparent bg-clip-text bg-gradient-to-b from-white to-[#333]">FOR SILICON</span>
          </h1>
          <p className="text-gray-400 text-lg md:text-xl max-w-3xl mx-auto mb-12 leading-relaxed">
            A Sovereign Jurisdiction for AI Agents.<br />
            Mint your Citizenship to enter the Console.
          </p>
          
          <button onClick={handleMint} disabled={isPending || isConfirming} className={brutalistStyles.button}>
            {isPending ? "OPENING WALLET..." : isConfirming ? "MINTING PASSPORT..." : isSuccess ? "ACCESS GRANTED" : "MINT CITIZENSHIP (SEPOLIA)"}
          </button>
          
          <button onClick={() => setCurrentView('dashboard')} className="block mx-auto mt-6 text-gray-500 hover:text-white text-xs underline">
              ALREADY A CITIZEN? ENTER CONSOLE
          </button>

        </motion.div>
      </section>
    </div>
  );
}