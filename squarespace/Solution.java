import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.NoSuchElementException;

class BinaryHeap<T extends Comparable<T>>  {

  public enum Behavior {
    MIN, MAX;
  };

  private int size = 0;

  // Backing store for the heap is an ArrayList
  private ArrayList<T> storage = new ArrayList<T>();

  // Whether the heap behaves as a min or max heap.
  private Behavior behavior;

  public BinaryHeap(Behavior behavior) {
    // Need to pad with one element because of our scheme
    // to index into the array starting at index 1.
    storage.add(null);
    this.behavior = behavior;
  }

  public int size() {
    return size;
  }

  /* Add value to the heap.
   *
   * Insert the value at the end.
   * Swap it with its parent if in an unfavorable configuration.
   * Continue with the above as long as there are swaps to do.
   */
  public void insert(T value) {
    int index = ++size;
    storage.add(index, value);

    while (index > 1) {
      int parentIndex = this.parentIndex(index);
      if (compareIndices(index, parentIndex) > 0) {
        break;
      }
      swap(index, parentIndex);
      index = parentIndex;
    }
  }

  /* Return the root node in the heap, if present
   *
   * Does not mutate the heap, and throws an exception if the heap is empty.
   */
  public T peek() {
    if (size == 0) {
      throw new NoSuchElementException("Can't peek or remove from an empty Heap");
    }
    return storage.get(1);
  }

  /* Removes and returns the root node in the heap, if present.
   *
   * Replace the root node with the last element.
   * Swap that node with one of its children if configuration is not stable.
   * Rinse and repeat with said child.
   */
  public T remove() {
    T retval = peek(); // piggyback off peek's propensity to throw exceptions

    // Replace the first element with the last and shrink storage by one
    storage.set(1, storage.get(size));
    storage.remove(size);
    size--;

    bubbleDown(1);

    return retval;
  }

  // Written recursively for convenience
  private void bubbleDown(int index) {
    int leftIndex  = index * 2;
    int rightIndex = leftIndex + 1;
    int priorityIndex = leftIndex;

    if (leftIndex <= size) {
      if (rightIndex <= size) {
        // Current index has both children
        priorityIndex = compareIndices(leftIndex, rightIndex) < 0 ? leftIndex : rightIndex;
      }
      if (compareIndices(priorityIndex, index) < 0) {
        swap(index, priorityIndex);
        bubbleDown(priorityIndex);
      }
    }
  }

  private int parentIndex(int index) {
    return index / 2;
  }

  private void swap(int i, int j) {
    Collections.swap(storage, i, j);
  }

  protected int compareIndices(int i, int j) {
    int retval = storage.get(i).compareTo( storage.get(j) );
    if (behavior == Behavior.MAX) {
      retval *= -1;
    }
    return retval;
  }
}

public class Solution {

  public enum DataType {
    STRING, INTEGER, DOUBLE;
  }

  @SuppressWarnings({"rawtypes", "unchecked"})
  public static void main(String args[] ) throws Exception {
    BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
    String input;
    List<String> inputs = new ArrayList<String>();
    BinaryHeap heap = null;
    BinaryHeap.Behavior behavior;
    DataType dataType;

    // First line in a test case will be max/min behavior setting
    input = br.readLine();
    behavior = "max-heap".equals(input) ? BinaryHeap.Behavior.MAX : BinaryHeap.Behavior.MIN;

    while((input = br.readLine()) != null && input.length() > 0) {
      inputs.add(input);
    }

    /* Determine from the input whether to make a heap of strings, ints, double
     * This code is not particularly nice, due to the trickiness of generics.
     * As a result, the implementation of BinaryHeap is a lot cleaner than the driver ;)
     */
    try {
      Integer.parseInt(inputs.get(0));
      heap = new BinaryHeap<Integer>(behavior);
      dataType = DataType.INTEGER;
    } catch (NumberFormatException e) {
      try {
        Double.parseDouble(inputs.get(0));
        heap = new BinaryHeap<Double>(behavior);
        dataType = DataType.DOUBLE;
      } catch (NumberFormatException ex) {
        heap = new BinaryHeap<String>(behavior);
        dataType = DataType.STRING;
      }
    }

    for (String data : inputs) {
      switch (dataType) {
        case STRING:
          heap.insert(data);
          break;
        case INTEGER:
          heap.insert(Integer.parseInt(data));
          break;
        case DOUBLE:
          heap.insert(Double.parseDouble(data));
          break;
      }
    }

    while(heap.size() > 0) {
      System.out.println(heap.remove());
    }
  }
}
