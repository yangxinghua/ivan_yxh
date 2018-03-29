# 选择排序
```
private void selectSort() {
    int[] array = {4,7,2,6,5,9,0,1};

    for(int i=0; i<array.length; i++) {
        int min = array[i];
        for(int j=i+1; j<array.length; j++) {
            if(array[j] < min) {
                int temp = array[j];
                array[j] = min;
                array[i] = temp;
                min = temp;
            }
        }
    }
}
```


# 冒泡排序
```
public void bubbleSort() {
  int[] array = {4,7,2,6,5,9,0,1};
  for(int j=0; j<array.length; j++) {
    for(int i= array.length -1; i<array.length - 1; i++) {
      if(array[i] > array[i+1]) {
        int temp = array[i+1];
        array[i+1] = array[i];
        array[i] = temp;
      }
    }
  }
}
```

# 快速排序
```
public void quickSort() {
  int nums = {6,3,2,4,1,9,5,7,8};
  int pivotPos = partition(nums, 0, nums.length -1);
  quickSort(nums, 0, pivotPos -1);
  quickSort(nums, pivotPos + 1, nums.length -1);
}

public int partition(int[] arr, int left, int right) {
  int pivotKey = arr[left];
  int pivotPos = left;

  while(left < rigth) {
      while(left < right && arr[right] > pivotKey)
          right --;
      while(left < right && arr[left] < pivotKey)
          left ++;

      swap(arr, left, right);
  }

  swap(arr, pivotPos, left);
  return left;

}

public void swap(int[] arr, int left, int right) {
    int temp = arr[left];
    arr[left] = arr[right];
    arr[right] = temp;
}
```
