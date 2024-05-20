#include "eidpliste.h"
#include <iostream>

/*
  implements Doubly Linked List: Liste.
*/
template<typename T> Liste<T>::Liste(Liste<T> const &liste)
{
    for (ListElement const *ptr = liste.sz; ptr != liste.ez; ptr = ptr->next) {
        append(ptr->data);
    }
}


template<typename T> Liste<T> const &Liste<T>::operator=(Liste<T> const &other)
{
    if (this == &other) {
        return *this;
    }
    clear();
    for (ListElement *ptr = other.sz; ptr != other.ez; ptr = ptr->next) {
        append(ptr->data);
    }
    return *this;
}


template<typename T> void Liste<T>::append(T const &x)
{
  ListElement *obj = new ListElement;
  obj->data = x;
  obj->next = nullptr;
  if (sz == nullptr) {
    sz = obj;
    obj->prev = nullptr;
  } else {
    obj->prev = ez;
    ez->next = obj;
    ez = obj;
  }
  ez = obj;
  ++counter;
}


template<typename T> void Liste<T>::clear(ListElement *obj)
{
    if (obj == nullptr)
      return;
    clear(obj->next);
    delete obj;
}


template<typename T> void Liste<T>::clear()
{
    clear(sz);
    sz = nullptr;
    ez = nullptr;
    counter = 0;
}


template<typename T> Liste<T>::~Liste()
{
    clear();
}


template<typename T>
unsigned int Liste<T>::size() const
{
    return counter;
}


template<typename T>
T Liste<T>::elementAt(unsigned int position) const
{
    ListElement *ptr = sz;
    while (position > 0) {
        if (ptr->next == nullptr) {
            throw std::range_error("Gesuchter Index ist zu gross.");
        }
        ptr = ptr->next;
        --position;
    }
    return ptr->data;
}


template <typename T> void Liste<T>::print(bool directionForward) {
  if (directionForward) {
    ListElement *ptr = sz;
    while (ptr != nullptr) {
      std::cout << ptr->data << " ";
      ptr = ptr->next;
    }
  } else {
    ListElement *ptr = ez;
    while (ptr != nullptr) {
      std::cout << ptr->data << " ";
      ptr = ptr->prev;
    }
  }
  std:: cout << std::endl;
}

template <typename T> void Liste<T>::reverse() {
  sz = ez;
  ListElement *ptr = sz;
  ListElement *ptr_prev = ptr->prev;
  sz->prev = nullptr;
  while (ptr_prev != nullptr) {
    ListElement * temp = ptr_prev->prev;
    ptr->next = ptr_prev;
    ptr_prev->prev = ptr;

    ptr = ptr_prev;
    ptr_prev = temp;
  }
  ez = ptr;
  ez->next = nullptr;
}


template <typename T> void Liste<T>::deleteAt(unsigned int position) {
  if (position > size() - 1) {
    std::cout << "invalid index" << std::endl;
  } else {
    // size matters.
    if (size() == 0) {
      std::cout << "List already empty!" << std::endl;
    }
    else if (size() == 1) {
      delete sz;
      sz = nullptr;
      ez = nullptr;
    }
    else {
      if (position == 0) {
        // lösche sz
        sz = sz->next;
        delete sz->prev;
        sz->prev = nullptr;
      } else if (position == size() - 1) {
        // lösche ez
        ez = ez->prev;
        delete ez->next;
        ez->next = nullptr;
      } else {
        unsigned int count = 0;
        ListElement *ptr = sz;
        while (count < position) {
          ptr = ptr->next;
          count++;
        }
        ptr->prev->next = ptr->next;
        ptr->next->prev = ptr->prev;
        delete ptr;
      } 
    }
    counter--;
  }
}

template class Liste<int>;
