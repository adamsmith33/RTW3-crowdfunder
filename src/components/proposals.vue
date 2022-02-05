<template>
    <div class="card" id="proposalsWindow">
        <h2>Current Campaigns</h2>
        <ul class='propList'>
            <li class="card propCard" v-if="!detailView" v-for="prop in proposals">
                <h2 class="propTitle">{{ prop.title }}</h2>
                <h3 class="propGoal">{{prop.fundingGoal}} Wei Goal!</h3>
                <p class="propDesc">{{ prop.description }}</p>
            </li>
        </ul>
    </div>
</template>

<script>
export default {
    name: 'proposals',
    data() {
        return {
            detailView: false
        }
    },
    computed: {
        proposals: function() {
            return this.$store.state.proposals;
        }
    },
    methods: {
        async fetchActiveProposals() {
            await this.$store.dispatch("getProposals");
        }
    },
    async mounted() {
        await this.fetchActiveProposals();
    }
}
</script>

<style scoped>
    #proposalsWindow {
        display: flex;
        flex-direction: column;
        text-align: center;
        width: 75%;
        min-height: 75vh;
        margin-left: auto;
        margin-right: auto;
    }

    .propList {
        list-style: none;
        display: flex;
        flex-direction: column;
        text-align: center;
        width: 80%;
        height: 55vh;
        margin-left: auto;
        margin-right: auto;
        overflow-y: scroll;
        overflow-x: hidden;
    }

    .propList::-webkit-scrollbar {
        width: 1vh;
    }

    .propList::-webkit-scrollbar-track {
        background: rgba(14, 14, 14, 0.1);
        border-radius: 10vh;
    }

    .propList::-webkit-scrollbar-thumb {
        background-color: #c4c4c4;
        border-radius: 10vh;
    }

    .propCard {
        display: flex;
        flex-direction: column;
        align-content: center;
        width: 80%;
        height: 60vh;
        margin-left: auto;
        margin-right: auto;
        margin-top: 1%;
        margin-bottom: 2%;
        filter: drop-shadow(10px 10px 15px rgba(14, 14, 14, 0.35));
        transition: all 0.3s ease-out;
    }

    .propCard:hover {
        cursor: pointer;
        transform: scale(1.015);
    }

    .propTitle {
        margin-bottom: 0;
    }

    .propGoal {

    }

    .propDesc {

    }
</style>