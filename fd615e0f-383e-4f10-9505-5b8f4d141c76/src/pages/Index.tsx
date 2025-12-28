import { useState, useEffect } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { Shield, AlertTriangle, Clock, CheckCircle2 } from 'lucide-react';

const Index = () => {
  const [quantumThreatActive, setQuantumThreatActive] = useState(false);
  const [remainingTimelock, setRemainingTimelock] = useState(0);
  const [activatedAt, setActivatedAt] = useState<number | null>(null);

  // Simulated contract state - replace with actual Web3 integration
  useEffect(() => {
    // This would be replaced with actual contract calls
    const mockData = {
      isQuantumThreatActive: false,
      defconZeroActivatedAt: 0,
      remainingTimelock: 0
    };
    
    setQuantumThreatActive(mockData.isQuantumThreatActive);
    setActivatedAt(mockData.defconZeroActivatedAt);
    setRemainingTimelock(mockData.remainingTimelock);
  }, []);

  const formatTimelock = (seconds: number) => {
    const days = Math.floor(seconds / 86400);
    const hours = Math.floor((seconds % 86400) / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    return `${days}d ${hours}h ${minutes}m`;
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-slate-950 via-slate-900 to-slate-950">
      {/* Hero Section */}
      <div className="relative overflow-hidden">
        <div 
          className="absolute inset-0 opacity-40"
          style={{
            backgroundImage: 'url(https://assets-gen.codenut.dev/images/1764639366_87f93ff2.png)',
            backgroundSize: 'cover',
            backgroundPosition: 'center'
          }}
        />
        <div className="absolute inset-0 bg-gradient-to-b from-transparent via-slate-950/50 to-slate-950" />
        
        <div className="relative max-w-7xl mx-auto px-6 py-24">
          <div className="text-center space-y-6">
            <div className="flex items-center justify-center gap-3">
              <Shield className="w-12 h-12 text-blue-400" />
              <h1 className="font-bold text-5xl text-white">0xZERO Protocol</h1>
            </div>
            <p className="text-xl text-slate-300 max-w-2xl mx-auto leading-relaxed">
              Quantum Threat Defense System
            </p>
            <p className="text-slate-400 max-w-3xl mx-auto leading-relaxed">
              A governance-controlled emergency response mechanism designed to protect against quantum computing threats with oracle integration and time-locked security measures.
            </p>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-6 py-12">
        {/* Status Alert */}
        {quantumThreatActive && (
          <Alert className="mb-8 border-red-500 bg-red-950/20">
            <AlertTriangle className="h-5 w-5 text-red-400" />
            <AlertDescription className="text-red-200">
              <strong>DEFCON ZERO ACTIVE:</strong> Quantum threat detected. Protocol is in emergency mode.
              {remainingTimelock > 0 && (
                <span className="block mt-2">
                  Timelock remaining: {formatTimelock(remainingTimelock)}
                </span>
              )}
            </AlertDescription>
          </Alert>
        )}

        {/* Status Cards */}
        <div className="grid md:grid-cols-3 gap-6 mb-12">
          <Card className="bg-slate-900/50 border-slate-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-white">
                <Shield className="w-5 h-5 text-blue-400" />
                Protocol Status
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex items-center gap-2">
                {quantumThreatActive ? (
                  <>
                    <Badge variant="destructive" className="bg-red-600">DEFCON ZERO</Badge>
                    <AlertTriangle className="w-4 h-4 text-red-400" />
                  </>
                ) : (
                  <>
                    <Badge className="bg-green-600">SECURE</Badge>
                    <CheckCircle2 className="w-4 h-4 text-green-400" />
                  </>
                )}
              </div>
            </CardContent>
          </Card>

          <Card className="bg-slate-900/50 border-slate-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-white">
                <Clock className="w-5 h-5 text-purple-400" />
                Governance Timelock
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-white">7 Days</p>
              <p className="text-sm text-slate-400 mt-1">Required for deactivation</p>
            </CardContent>
          </Card>

          <Card className="bg-slate-900/50 border-slate-800">
            <CardHeader>
              <CardTitle className="text-white">Activation Time</CardTitle>
            </CardHeader>
            <CardContent>
              {activatedAt && activatedAt > 0 ? (
                <p className="text-sm text-slate-300">
                  {new Date(activatedAt * 1000).toLocaleString()}
                </p>
              ) : (
                <p className="text-slate-500">Not activated</p>
              )}
            </CardContent>
          </Card>
        </div>

        {/* Contract Information */}
        <Card className="bg-slate-900/50 border-slate-800 mb-8">
          <CardHeader>
            <CardTitle className="text-white">Constitution Contract</CardTitle>
            <CardDescription className="text-slate-400">
              Deployed on Codenut Devnet
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <p className="text-sm text-slate-400 mb-1">Contract Address</p>
              <code className="text-xs bg-slate-950 px-3 py-2 rounded block text-blue-300 font-mono">
                0x914b7ffd0a5a0204f7d7203071f00e786e573983
              </code>
            </div>
            <div>
              <p className="text-sm text-slate-400 mb-1">Network</p>
              <p className="text-white">Codenut Devnet (Chain ID: 20258)</p>
            </div>
          </CardContent>
        </Card>

        {/* Features Grid */}
        <div className="grid md:grid-cols-2 gap-6">
          <Card className="bg-slate-900/50 border-slate-800">
            <CardHeader>
              <CardTitle className="text-white">Quantum Oracle Integration</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-slate-300 leading-relaxed">
                Only authorized quantum oracle addresses can trigger DEFCON ZERO state, ensuring verified quantum threat detection before emergency activation.
              </p>
            </CardContent>
          </Card>

          <Card className="bg-slate-900/50 border-slate-800">
            <CardHeader>
              <CardTitle className="text-white">7-Day Governance Timelock</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-slate-300 leading-relaxed">
                Deactivation requires a mandatory 7-day waiting period, allowing community review and preventing hasty decisions during critical security events.
              </p>
            </CardContent>
          </Card>

          <Card className="bg-slate-900/50 border-slate-800">
            <CardHeader>
              <CardTitle className="text-white">Owner-Controlled Oracle</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-slate-300 leading-relaxed">
                Contract owner can update the quantum oracle address, maintaining flexibility while preserving security through access control mechanisms.
              </p>
            </CardContent>
          </Card>

          <Card className="bg-slate-900/50 border-slate-800">
            <CardHeader>
              <CardTitle className="text-white">Transparent State Tracking</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-slate-300 leading-relaxed">
                All activation events, timestamps, and status changes are recorded on-chain with comprehensive event logging for full audit transparency.
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Action Buttons */}
        <div className="mt-12 flex gap-4 justify-center">
          <Button 
            size="lg" 
            className="bg-blue-600 hover:bg-blue-700"
            disabled
          >
            Connect Wallet
          </Button>
          <Button 
            size="lg" 
            variant="outline"
            className="border-slate-700 text-slate-300 hover:bg-slate-800"
            disabled
          >
            View Contract
          </Button>
        </div>

        <p className="text-center text-sm text-slate-500 mt-6">
          Web3 integration coming soon. Connect your wallet to interact with the Constitution contract.
        </p>
      </div>
    </div>
  );
};

export default Index;
