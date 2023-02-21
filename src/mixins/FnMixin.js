import debounce from "@/utils/debounce";
import throttle from "@/utils/throttle";

const FnMixin = {
  data(){
    return {
        debounce,
        throttle
    }
  }
}

export default FnMixin