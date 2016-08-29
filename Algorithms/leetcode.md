1. Given an array of integers, find if the array contains any duplicates. Your function should return true if any value appears at least twice in the array, and it should return false if every element is distinct.

先进行排序，再比较。
```
public boolean solution(int[] nums) {
  Array.sort(nums);
  for(int i=0; i< nums.length - 1; i++) {
    if(nums[i] == nums[i+1]) {
      return true;
    }
  }
  return false;
}
```

2. Write a function that takes a string as input and returns the string reversed.

```
public void solution(String s) {
  char[] array = s.toCharArray();
  int start = 0;
  int end = array.length - 1;
  while(start < end) {
    char temp = array[start];
    array[start] = array[end];
    array[end] = temp;

    start++;
    end--;
  }
  return new String(array);
}

```

3. You are playing the following Nim Game with your friend: There is a heap of stones on the table, each time one of you take turns to remove 1 to 3 stones. The one who removes the last stone will be the winner. You will take the first turn to remove the stones.
Both of you are very clever and have optimal strategies for the game. Write a function to determine whether you can win the game given the number of stones in the heap.
For example, if there are 4 stones in the heap, then you will never win the game: no matter 1, 2, or 3 stones you remove, the last stone will always be removed by your friend.

```
public boolean solution(int n) {
  return n%4 != 0;
}
```

4. Calculate the sum of two integers a and b, but you are not allowed to use the operator + and -. Example:Given a = 1 and b = 2, return 3.
```
public int solution(int a, int b) {
    int x = a & b;
    if(x == 0) {
      return a|b;
    } else {
      x = x << 1;
      int y = a ^ b;
      return solution(x, y);
    }
}
```

5. Given a non-negative integer num, repeatedly add all its digits until the result has only one digit.
For example:
Given num = 38, the process is like: 3 + 8 = 11, 1 + 1 = 2. Since 2 has only one digit, return it.

```
public class Solution {
    public int addDigits(int num) {
        if (num == 0){
            return 0;
        }
        if (num % 9 == 0){
            return 9;
        }
        else {
            return num % 9;
        }
    }
}

```
explain:
Say a number x = 23456
x = 2* 10000 + 3 * 1000 + 4 * 100 + 5 * 10 + 6
2 * 10000 % 9 = 2 % 9
3 * 1000 % 9 = 3 % 9
4 * 100 % 9 = 4 % 9
5 * 10 % 9 = 5 % 9
Then x % 9 = ( 2+ 3 + 4 + 5 + 6) % 9,
note that x = 2* 10000 + 3 * 1000 + 4 * 100 + 5 * 10 + 6
So we have 23456 % 9 = (2 + 3 + 4 + 5 + 6) % 9

6. Given a binary tree, find its maximum depth.
The maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.
```
public int maxDepth(Tree root) {
  if(root == null) {
    return 0;
  } else {
    return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
  }
}
```

7. Invert a binary tree.

```

     4
   /   \
  2     7
 / \   / \
1   3 6   9
to
     4
   /   \
  7     2
 / \   / \
9   6 3   1

```
```
public class Solution {
    public TreeNode invertTree(TreeNode root) {
        if(root == null) {
          return root;
        } else {
          TreeNode temp = root.left;
          root.left = root.right;
          root.right = temp;
          invertTree(root.left);
          invertTree(root.right);
        }


    }
}
```

7. Given an array nums, write a function to move all 0's to the end of it while maintaining the relative order of the non-zero elements.
For example, given nums = [0, 1, 0, 3, 12], after calling your function, nums should be [1, 3, 12, 0, 0].

```
public void moveZeroes(int[] nums) {
    if (nums == null || nums.length == 0) return;        

    int insertPos = 0;
    for (int num: nums) {
        if (num != 0) nums[insertPos++] = num;
    }        

    while (insertPos < nums.length) {
        nums[insertPos++] = 0;
    }
}
```
