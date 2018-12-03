<template >
  <div>
    <Swiper
      ref="swiper"
      v-if="list.length > 0"
      :autoPlay="true"
      :showIndicator="true"
      interval="2500"
      duration="500"
    >
      <Slide @click="clickMe" v-for="(tag,key) in list" :key="key">
        <img :src="tag.img">
      </Slide>
    </Swiper>
     
    <div>
      <button @click="preve">上一张</button>
    </div>
    <div>
      <button @click="next">下一张</button>
    </div>
 </div>
</template>

<script>
import { Swiper, Slide } from "vue-swiper-component";
export default {
  data() {
    return {
      list: [
        {
          img:
            "https://qiniu.epipe.cn/5456575529551388672?imageslim&imageView2/1/w/750/h/360"
        },
        {
          img:
            "https://qiniu.epipe.cn/5430983074181545984?imageslim&imageView2/1/w/750/h/360"
        },
        {
          img:
            "https://qiniu.epipe.cn/5464226412548325376?imageslim&imageView2/1/w/750/h/360"
        }
      ]
    };
  },
  components: {
    Swiper,
    Slide
  },
  methods: {
    clickMe(index) {
      console.log(index);
    },
    preve() {
      this.$refs.swiper.prevSlide();
    },
    next() {
      this.$refs.swiper.nextSlide();
    }
  }
};
</script>

<style scoped>
.userinfo {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.userinfo-avatar {
  width: 128rpx;
  height: 128rpx;
  margin: 20rpx;
  border-radius: 50%;
}

.userinfo-nickname {
  color: #aaa;
}

.usermotto {
  margin-top: 150px;
}

.form-control {
  display: block;
  padding: 0 12px;
  margin-bottom: 5px;
  border: 1px solid #ccc;
}

.counter {
  display: inline-block;
  margin: 10px auto;
  padding: 5px 10px;
  color: blue;
  border: 1px solid blue;
}
</style>
