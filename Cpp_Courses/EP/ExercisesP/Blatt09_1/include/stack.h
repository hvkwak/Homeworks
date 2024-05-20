#ifndef STACK_H_
#define STACK_H_


#include <cstdlib>
#include <iostream>


using namespace std;

template <class T>
class Stack {

  struct StackElement {
    T data;
    StackElement *next;

    // add a constructor for const T.
    StackElement() : data(), next(nullptr) {}
    StackElement(T x, StackElement *p_next) : data(x), next(p_next) {
      if (p_next == nullptr) {
        std::cout << "nullptr is next!" << std::endl;
      }
    }
  };

public:
  
  // constructor, destructors
  Stack();
  Stack(const Stack<T> &obj);
  ~Stack();
  Stack<T> &operator=(const Stack<T> &obj);

  // empty, push, pop, clear..
  bool empty() const;
  void push(T x);
  void pop();
  StackElement *top() const;

  void clear();
  void printStatus();
  
  
private:
  StackElement *top_element;

    
};

#endif /* STACK_H_ */
