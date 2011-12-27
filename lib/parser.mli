
(*
  OCaml HTTP - do it yourself (fully OCaml) HTTP daemon

  Copyright (C) <2002-2005> Stefano Zacchiroli <zack@cs.unibo.it>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU Library General Public License as
  published by the Free Software Foundation, version 2.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Library General Public License for more details.

  You should have received a copy of the GNU Library General Public
  License along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
  USA
*)

(** HTTP messages parsing *)

open Types;;

  (** given an HTTP like query string (e.g. "name1=value1&name2=value2&...")
  @return a list of pairs [("name1", "value1"); ("name2", "value2")]
  @raise Malformed_query if the string isn't a valid query string
  @raise Malformed_query_part if some piece of the query isn't valid
  *)
val split_query_params: string -> (string * string) list

  (** parse 1st line of an HTTP request
  @param inchan input channel from which parse request
  @return a triple meth * url * version, meth is the HTTP method invoked, url is
  the requested url, version is the HTTP version specified or None if no version
  was specified
  @raise Malformed_request if request 1st linst isn't well formed
  @raise Malformed_request_URI if requested URI isn't well formed *)
val parse_request_fst_line: Lwt_io.input_channel -> (meth * Url.t * version) Lwt.t

  (** parse 1st line of an HTTP response
   * @param inchan input channel from which parse response
   * @raise Malformed_response if first line isn't well formed
  *)
val parse_response_fst_line: Lwt_io.input_channel -> (version * status) Lwt.t

  (** parse HTTP headers. Consumes also trailing CRLF at the end of header list
  @param inchan input channel from which parse headers
  @return a list of pairs header_name * header_value
  @raise Invalid_header if a not well formed header is encountered *)
val parse_headers: Lwt_io.input_channel -> ((string * string) list) Lwt.t

  (** given an input channel, reads from it a GET HTTP request and
  @return a pair <path, query_params> where path is a string representing the
  requested path and query_params is a list of pairs <name, value> (the GET
  parameters) *)
val parse_request: Lwt_io.input_channel -> (string * (string * string) list) Lwt.t

  (** parse content-range header in a request
  @return number of bytes to read, or None if all available should be read
  *)
val parse_content_range: (string * string) list -> int option


