# Critical Appraisal

## General Information

**Group Members:** Eleas Vrahnos

**Date of Submission:** 
- December 4, 2022 (Part 1)
- December ?, 2022 (Part 2)

**Completed Contents of Assignment 3:**
- `test/solutions.lc`
- `test/sort.lc`

**Uncompleted Contents of Assignment 3:** None

**Known Bugs/Problems:** None

## Overall Notes and Thoughts

This assignment built on top of the knowledge gained from Assignment 2, with this assignment now featuring more familiar syntax for lists and user-created functions. It also used previous knowledge of linked lists in order to create list functions, like the examples of `insert` and `sort`. While it was a healthy review of linked lists and pointers, it also demonstrated the power of using this grammar with the stack and heap, as it acts more like a modern functional programming language.

Throughout this assignment, I learned that there can be many possible implementations of these functions, each with their own pros and cons. Using my implementation of `insert` as an example, a significant advantage is not having to create many pointers on the stack. All that is required to make are the `elem` pointers that reference each element in the heap, as well as a `curr` pointer that help iterate through a list in the stack. This helps reduce stack space, and can potentially be beneficial for larger-scale programs where space is more of an issue. Another possible implementation could have a `next` pointer as well to help with `insert` location, but comes at the small cost of taking some space in the stack. A disadvantage my implementation has is the inability to reference `nil` in the `case` statements. For a reason unknown to me, using `list` to reference `nil` does not work, but using `!list` to reference `NULL` does. This leads to a slightly messier implementation, yet it does not produce any errors. This could be worth exploring more into.

Another challenge while implementing these functions was testing them through the debug code shown in `sort.lc`. In the end, it helped me decide the final implementation of the code. For example, my first `insert` function version required that a list first be created, then giving the list its contents after. This is different than my current iteration, which creates the list with its contents once. These different versions of creating the function leads to different usages of pointers, and ended up changing my entire code. This was mainly due to some small bugs with `print` and `sort` that made it much harder to correctly debug.

Finally, creating this picture below helped me determine the order on what to check before inserting an element into the list. Drawing pictures throughout this entire assignment helped significantly, and outlining the function itself was no exception.

<p align="center">
  <img src="https://cdn.discordapp.com/attachments/619802365477912596/1050927890109300778/image.png" width="600">
</p>

## Further Analysis

Pseudocode for my implementation of the `insert n list` function:

```
(Create curr pointer beforehand on the stack)

create elem pointer
if list is nil:                                                     (empty list case)
    insert element into empty list
else:
    set curr pointer to beginning of list
    if n <= number in first element:                                (prepend case)
        insert element before list
    else:
        set elem pointer to [n, "NULL"]
        while elem = [n, "NULL"]:
            if the element after the current element is "NULL":     (append case)
                insert element after list
            else:
                if n <= number in current element:                  (in between two elements case)
                    insert element right after curr
                else:
                    shift curr pointer forward one
        set curr pointer to beginning of list
```

The following will be a visual walkthrough of the input `insert 3 (insert 1 (insert 4 (insert 2 nil)))`. 

### Step 1: `insert 2 nil`

Because the list is `nil`, the empty list case will execute, adding `2` as the lone element in the list.

<p align="center">
  <img src="https://media.discordapp.net/attachments/619802365477912596/1050939915879338054/image.png" width="600">
</p>

### Step 2: `insert 4 (insert 2 nil)`

Because `4 > 2`, the append case will execute, adding `4` to the end of the list after `2`.

<p align="center">
  <img src="https://media.discordapp.net/attachments/619802365477912596/1050939995441090600/image.png" width="600">
</p>

### Step 3: `insert 1 (insert 4 (insert 2 nil))`

<p align="center">
  <img src="https://media.discordapp.net/attachments/619802365477912596/1050940080749027488/image.png" width="600">
</p>

### Step 4: `insert 3 (insert 1 (insert 4 (insert 2 nil)))`

Because `2 < 3 < 4`, the in between two elements case will execute, adding `3` after `2` and before `4`.

<p align="center">
  <img src="https://media.discordapp.net/attachments/619802365477912596/1050940209690316941/image.png" width="600">
</p>