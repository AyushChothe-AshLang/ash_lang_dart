fn main() {
  let i = 0, nums = [1, 2, 2, 3, 3, 3], counter = {};
  while (i < len(nums)) {
    let num = at(nums, i);
    if (!isPresent(counter, num)) {
      set(counter, num, 1);
    } else {
      let val = get(counter, num);
      set(counter, num, val + 1);
    }
    i += 1;
  }
  println(counter);
}