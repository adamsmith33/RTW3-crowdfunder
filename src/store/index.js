import { ethers } from 'ethers';
import { createStore } from 'vuex'
import abi from './utils/crowdFund.json'

export default createStore({
  state: {
    account: null,
    error: null,
    mining: false,
    currentNetwork: null,
    proposals: null,
    contract_address: '0x6d74726dcb5a20f86575A156acC86E059A559327',
    contract_abi: abi.abi
  },
  mutations: {
    setAccount(state, account) {
      state.account = account;
    },
    setError(state, error) {
      state.error = `${error}`;
    },
    setNetwork(state, network) {
      state.currentNetwork = `${network}`;
    },
    toggleMining(state, status) {
      state.mining = status;
    },
    updateProposals(state, proposals) {
      state.proposals = proposals;
    }
  },
  actions: {
    async connect({ commit, dispatch }, connect) {
      try {
        const { ethereum } = window;

        if(!ethereum){
          commit("setError", "Metamask not installed!");
          return;
        }

        if(!(await dispatch("checkIfConnected") && connect)) {
          await dispatch("requestAccess");
        }

        await dispatch("checkNetwork");

      } catch(error) {
        //console.log(error);
        commit("setError", "Account request refused.");
      }
    },
    async checkNetwork({ commit, dispatch }) {
        let chainId = await ethereum.request({ method: "eth_chainId" });
        const rinkebyChainId = "0x13881";
        if(chainId !== rinkebyChainId){
          if(!(await dispatch("switchNetwork"))) {
            commit("setNetwork", chainId);
            commit("setError", "You are not connected to the Rinkeby Test Network.");
          } else {
            chainId = await ethereum.request({ method: "eth_chainId" });
            commit("setNetwork", chainId);
          }
        } else {
          commit("setNetwork", chainId);
        }
      },
    async switchNetwork() {
      try {
        await ethereum.request({
          method: "wallet_switchEthereumChain",
          params: [{ chainId: "0x13881" }]
        });

      return 1;
      } catch(error){
        commit("setError", error);
        return 0;
      }
    },
    async checkIfConnected({ commit }) {
      const { ethereum } = window;
      const accounts = await ethereum.request({ method: "eth_accounts" });

      if(accounts.length !== 0) {
        commit("setAccount", accounts[0]);
        return 1;
      } else {
        return 0;
      }
    },
    async requestAccess({ commit }) {
      const { ethereum } = window;
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      commit("setAccount", accounts[0]);
    },
    async getProposals({ state, commit }) {
      const { ethereum } = window;
      if(!ethereum) {
        alert("Please install Metamask!");
        return;
      }

      const provider = new ethers.providers.Web3Provider(ethereum);
      const signer = provider.getSigner();
      const crowdFundContract = new ethers.Contract(state.contract_address, state.contract_abi, signer);

      let txn = await crowdFundContract.getActivePropDetails();

      commit("updateProposals", txn);

    }
  },
  modules: {
  }
})
