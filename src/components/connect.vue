<template>
    <div id="metamaskWindow" class="card">
        <h2>Welcome to the Automat. Please connect your metamask to continue!</h2>
        <button class="connectButton" @click="connect">Connect</button>
    </div>
</template>

<script>
export default {
    name: 'connect',
    props: {

    },
    data() {
        return {

        }
    },
    computed: {

    },
    methods: {
    async connect() {
        await this.$store.dispatch("connect", true);
    }
    } 
}
</script>

<style scoped>
    #metamaskWindow {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 35%;
    height: 15%;
    padding-bottom: 5vh;
    padding-top: 3vh;
    padding-left: 5%;
    padding-right: 5%;
    margin-top: 12%;
    margin-left: auto;
    margin-right: auto;
    }

    .connectButton {
        width: 20vh;
        height: 5vh;
        margin-top: 3vh;
        border-radius: 2vh;
        border: none;
        color: white;
        background-color: #1CB5E0;
        transition: all 0.1s;
    }

    .connectButton:hover {
        cursor: pointer;
        transform: scale(1.03);
    }
</style>