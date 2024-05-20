#include "stack.h"

template <typename T> Stack<T>::Stack() : top_element(nullptr) {}

template <typename T> Stack<T>::Stack(const Stack<T> &obj) {

  top_element = nullptr;

  // get the size of the stack in obj. could be easier with std::vector.
  int n = 0;
  StackElement *top = obj.top();
  while (top != nullptr) {
    top = top->next;
    n++;
  }

  // get the StackElement and keep it in an array
  if (n > 0){
    StackElement *element = new StackElement[n];
    top = obj.top();
    for (int i = n-1; 0 <= i; i--) {
      element[i].data = top->data;
      element[i].next = top->next;
      top = top->next;
    }
    // copy the elements.
    for (int i = 0; i < n; i++) {
      push(element[i].data);
    }
    delete [] element;
  } 
}

template <typename T> Stack<T>::~Stack() {clear();}

template <typename T> Stack<T> & Stack<T>::operator=(const Stack<T> &obj) { 
  if (this == &obj) {
    return *this;
  }
    
  // init top_element
  top_element = nullptr;

  // get the size of the stack in obj. could be easier with std::vector.
  int n = 0;
  StackElement *top = obj.top();
  while (top != nullptr) {
    top = top->next;
    n++;
  }

  // get the StackElement and keep it in an array
  if (n > 0){
    StackElement *element = new StackElement[n];
    top = obj.top();
    for (int i = n-1; 0 <= i; i--) {
      element[i].data = top->data;
      element[i].next = top->next;
      top = top->next;
    }
    // copy the elements.
    for (int i = 0; i < n; i++) {
      push(element[i].data);
    }
    delete [] element;
  }    
  return *this;
};

template <typename T> bool Stack<T>::empty() const { return top_element == nullptr; }

template <typename T> void Stack<T>::push(T x) {top_element = new StackElement(x, top_element);};


template <typename T> void Stack<T>::pop() {
  if (top_element == nullptr) {
    exit(1);
  } else {
    StackElement *temp = top_element;
    top_element = top_element->next;
    delete temp;
  }
}

template <typename T> typename Stack<T>::StackElement* Stack<T>::top() const{
  if (empty()) {
    exit(1);
  } else {
    return top_element;    
  }
}

template <typename T> void Stack<T>::clear() {
  while (top_element != nullptr) {
    pop();
  }
}

template <typename T> void Stack<T>::printStatus() {
  std::cout << "this: " << this << ", ";
  StackElement *element = top();
  while (element != nullptr) {
    std::cout << element->data << "(" << element << ")" << " ";
    element = element->next;
  }
  std::cout << " " << std::endl;
};


// Explicitly instantiate the template.
template class Stack<int>;
template class Stack<string>;
