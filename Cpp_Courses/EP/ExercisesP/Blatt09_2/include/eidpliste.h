#ifndef EIDPLISTE_H_
#define EIDPLISTE_H_


#include <stdexcept>

template <typename T>
class Liste {
  
  struct ListElement {
    T data;
    ListElement *prev;
    ListElement *next;
  };

public:
  Liste() = default;
  Liste(Liste<T> const &liste);
  Liste<T> const &operator=(Liste<T> const &other);
  virtual ~Liste();

  void append(T const &x);
  void clear();
  void print(bool directionForward);
  void reverse();
  unsigned int size() const;
  T elementAt(unsigned int position) const;
  void deleteAt(unsigned int position);

private:
  void clear(ListElement *obj);
  ListElement *sz = nullptr;
  ListElement *ez = nullptr;
  unsigned int counter = 0;
};

#endif /* EIDPLISTE_H_ */
