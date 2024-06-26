package com.example.repository;

import com.example.entity.Book;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BookMapper {
    List<Book> bookList();
    void saveBook(Book dto);
    void registerBook(Book dto);
    Book get(int num);
    void remove(int num);
    void update(Book dto);
}
