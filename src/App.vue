<template>
  <ul id="header">
    <li class="navItem"><div id="wordMark">FUNDMATIC</div></li>
    <li class="navItem" id="navs"><div>Home</div></li>
  </ul>
  <div>
      <transition name="fade" mode="out-in">
        <component v-bind:is="currentComponent"></component>
        <!--<collection/>-->
      </transition>
  </div>
</template>

<script>
import store from './store/index.js'
import connect from './components/connect.vue'
import proposals from './components/proposals.vue'
import { ethers } from 'ethers'

export default {
  name: 'App',
  store: store,
  components: {
    connect,
    proposals
  },
  data() {
    return {
      active: "connect"
    }
  },
  computed: {
    getAddress: function () {
      return this.$store.state.account
    },
    networkConnected: function () {
      return (this.$store.state.currentNetwork === "0x13881")
    },
    getNetwork: function () {
      return this.$store.state.currentNetwork;
    },
    currentComponent: function () {
      if(!this.networkConnected){
        return "connect";
      } else {
          return "proposals"
        } 
    }
  },
  methods: {
      async connect() {
        await this.$store.dispatch("connect", true);
    },
  },
  async mounted() {
    await this.connect();
  }
}
</script>

<style>
#app {
  color: white;
}

.fade-enter-active, .fade-leave-active {
  transition: all .4s ease;
}
.fade-enter-from, .fade-leave-to {
  transform: translatey(40px);
  opacity: 0;
}
</style>
