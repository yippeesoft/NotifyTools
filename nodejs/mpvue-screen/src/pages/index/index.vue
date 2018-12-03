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
        <img :src="tag.img" mode="aspectFill">
      </Slide>
    </Swiper>
     
    <div>
      <button @click="preve">上一张</button>
    </div>

    <swiper  indicator-dots>
      <swiper-item class="md-splash__item"  v-for="(item, index) in list" :for-index="index" :key="index">
        <image :src="item.img" class="md-splash__image" mode="aspectFill"/>
        <button class="md-splash__start" @click="handleStart" v-if="index === list.length - 1">立即体验</button>
      </swiper-item>
    </swiper>

    <div>
      <button @click="next">下一张</button>
    </div>
 </div>
</template>

<script>
 
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

<style lang="scss">
page {
  height: 100%;
}

@include c('splash') {
  height: 100%;

  @include e('swiper') {
    height: 100%;
  }

  @include e('item') {
    flex: 1;
  }

  @include e('image') {
    position: absolute;
    height: 100%;
    width: 100%;
    opacity: .9;
  }

  @include e('start') {
    position: absolute;
    bottom: 200rpx;
    left: 50%;
    width: 300rpx;
    margin-left: -150rpx;
    background-color: rgba(64, 88, 109, .4);
    color: #fff;
    border: 1rpx solid rgba(64, 88, 109, .8);
    border-radius: 200rpx;
    font-size: 40rpx;
  }
}

</style>
