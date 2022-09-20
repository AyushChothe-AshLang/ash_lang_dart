fn sumOfNum(num){
  if (num < 10) {
    return num;
  }
  let digit = 0, sum = 0;
  while (num != 0) {
    digit = num % 10;
    sum += digit;
    num = int(num / 10);
  }
  return sumOfNum(sum);
}

fn main(){
  let n = int(input("Enter a number: "));
  print(sumOfNum(n));
}